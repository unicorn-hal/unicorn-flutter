import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_standby.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_status.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine_request.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Api/Call/call_api.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';
import 'package:unicorn_flutter/Service/Api/Medicine/medicine_api.dart';
import 'package:unicorn_flutter/Service/Firebase/Firestore/firestore_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class HomeController extends ControllerCore {
  FirebaseFirestoreService get _firestoreService =>
      FirebaseFirestoreService(databaseId: 'call-log');
  CallApi get _callApi => CallApi();
  DoctorApi get _doctorApi => DoctorApi();
  MedicineApi get _medicineApi => MedicineApi();

  HomeController(this.context);
  BuildContext context;

  // todo: 仮データ
  final List<Map<String, dynamic>> _boardList = [
    {
      'title': 'タイトル1',
      'content': '内容1',
      'imageUrl': 'https://picsum.photos/200/300',
    },
    {
      'title': 'タイトル2',
      'content': '内容2',
      'imageUrl': 'https://picsum.photos/200/300',
    },
    {
      'title': 'タイトル3',
      'content': '内容3',
      'imageUrl': 'https://picsum.photos/200/300',
    },
  ];

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.amber,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.cyan,
  ];

  // todo: APIから取得時に命名も見直し
  int carouselIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  ValueNotifier<CallStandby?> callStandbyNotifier =
      ValueNotifier<CallStandby?>(null);

  StreamSubscription<QuerySnapshot<Object?>>? _callStandbySubscription;

  @override
  void initialize() async {
    _callReservationsListener();
  }

  List<Color> get colors => _colors;
  List<Map<String, dynamic>> get boardList => _boardList;
  CarouselSliderController get carouselController => _carouselController;

  /// 通話待機中の予約情報を取得
  void _callReservationsListener() {
    final String collection = UserData().user!.userId;
    _callStandbySubscription = _firestoreService.streamData(collection).listen(
      (event) async {
        try {
          await Future.delayed(const Duration(seconds: 2));
          final filteredData = event.docs.where((doc) {
            final data =
                CallStatus.fromJson(doc.data() as Map<String, dynamic>);
            return data.isDoctorEntered;
          }).toList();
          if (filteredData.isEmpty) {
            callStandbyNotifier.value = null;
            return;
          }
          final String reservationId = filteredData.first.id;
          Log.echo('reservationId: $reservationId');

          Call call = await _getCall(reservationId);
          Doctor doctor = await _getDoctor(call.doctorId);
          String callStartTime = DateFormat('yyyy/MM/dd HH:mm')
              .format(call.callStartTime.toLocal());
          String callEndTime =
              DateFormat('HH:mm').format(call.callEndTime.toLocal());

          CallStandby callStandby = CallStandby(
            callReservationId: reservationId,
            doctorName: '${doctor.lastName} ${doctor.firstName}',
            doctorIconUrl: doctor.doctorIconUrl,
            hospitalName: doctor.hospital.hospitalName,
            reservationDateTimes: '$callStartTime 〜 $callEndTime',
          );

          callStandbyNotifier.value = callStandby;
        } catch (e) {
          Log.echo('Error: $e');
          callStandbyNotifier.value = null;
        }
      },
    );
  }

  Future<Call> _getCall(String reservationId) async {
    final res = await _callApi.getCall(callReservationId: reservationId);
    if (res == null) {
      throw Exception('Call data is null');
    }
    return res;
  }

  Future<Doctor> _getDoctor(String doctorId) async {
    final res = await _doctorApi.getDoctor(doctorId: doctorId);
    if (res == null) {
      throw Exception('Doctor data is null');
    }
    return res;
  }

  Future<void> goVideoCall() async {
    if (callStandbyNotifier.value == null) {
      // tips: View自体が表示されないので、基本的には発生しない
      return;
    }

    final CallStandby callStandby = callStandbyNotifier.value!;
    // ignore: use_build_context_synchronously
    VideoCallRoute($extra: callStandby).go(context);
    callStandbyNotifier.value = null;
  }

  Future<void> takeMedicine(Medicine medicine) async {
    int requestQuantity = medicine.quantity - medicine.dosage;
    if (requestQuantity <= 0) {
      requestQuantity = 0;
    }
    MedicineRequest medicineRequest = MedicineRequest(
      medicineName: medicine.medicineName,
      count: medicine.count,
      quantity: requestQuantity,
      dosage: medicine.dosage,
      reminders: medicine.reminders,
    );
    final putRes = await _medicineApi.putMedicine(
        medicineId: medicine.medicineId, body: medicineRequest);
    if (putRes == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      return;
    }
    Fluttertoast.showToast(msg: Strings.MEDICINE_TAKE_COMPLETED_MESSAGE);
  }

  void dispose() {
    _callStandbySubscription?.cancel();
    _firestoreService.dispose();
    callStandbyNotifier.dispose();
  }
}
