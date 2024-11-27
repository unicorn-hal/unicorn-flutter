import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_standby.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_status.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Service/Api/Call/call_api.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';
import 'package:unicorn_flutter/Service/Firebase/Firestore/firestore_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class HomeController extends ControllerCore {
  FirebaseFirestoreService get _firestoreService =>
      FirebaseFirestoreService(databaseId: 'call-log');
  CallApi get _callApi => CallApi();
  DoctorApi get _doctorApi => DoctorApi();

  // todo: 変数はすべてControllerから取得する
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

  final List<Map<String, dynamic>> _medicineList = [
    {
      'name': 'カロナール',
      'remainingDays': 7,
      'remainingCount': 7,
      'progressColor': Colors.green,
      'currentNum': 2,
      'totalNum': 14,
    },
    {
      'name': 'アポトキシン4869',
      'remainingDays': 5,
      'remainingCount': 30,
      'progressColor': Colors.red,
      'currentNum': 8,
      'totalNum': 25,
    },
  ];

  int currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  ValueNotifier<CallStandby?> callStandbyNotifier =
      ValueNotifier<CallStandby?>(null);

  @override
  void initialize() async {
    _callReservationsListener();
  }

  List<Map<String, dynamic>> get boardList => _boardList;
  List<Map<String, dynamic>> get medicineList => _medicineList;
  CarouselSliderController get carouselController => _carouselController;

  void _callReservationsListener() {
    final String collection = UserData().user!.userId;
    _firestoreService.streamData(collection).listen(
      (event) async {
        try {
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

          Call call = await _getCall(reservationId);
          Doctor doctor = await _getDoctor(call.doctorId);
          String callStartTime =
              DateFormat('yyyy/MM/dd HH:mm').format(call.callStartTime);
          String callEndTime = DateFormat('HH:mm').format(call.callEndTime);

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

  void dispose() {
    callStandbyNotifier.dispose();
  }
}
