import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Model/Cache/Doctor/Information/doctor_information_cache.dart';
import 'package:unicorn_flutter/Model/Cache/Doctor/PrimaryDoctors/primary_doctors_cache.dart';
import 'package:unicorn_flutter/Model/Entity/PrimaryDoctor/primary_doctors_request.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';
import 'package:unicorn_flutter/Service/Api/PrimaryDoctor/primary_doctor_api.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

import '../../../../Model/Entity/Doctor/doctor.dart';
import '../../../Core/controller_core.dart';

class DoctorInformationController extends ControllerCore {
  DoctorApi get _doctorApi => DoctorApi();
  PrimaryDoctorApi get _primaryDoctorApi => PrimaryDoctorApi();
  DoctorInformationController(
    this._doctorId,
  );

  late List<Doctor>? _doctorInformationCache;
  final String _doctorId;
  late bool _exist;
  late ValueNotifier<bool> _primary;

  @override
  void initialize() {
    _doctorInformationCache = DoctorInformationCache().data;
    _exist = _checkExist();
    _primary = ValueNotifier(isPrimaryDoctor());
  }

  bool get exist => _exist;
  ValueNotifier<bool> get primary => _primary;

  // キャッシュしたデータの中に指定したIDの医師情報があるかを確認
  bool _checkExist() {
    return _doctorInformationCache!
        .any((element) => element.doctorId == _doctorId);
  }

  // APIで医師情報を取得
  Future<Doctor?> getDoctor() async {
    await cacheDoctorList();
    final Doctor? doctor = await _doctorApi.getDoctor(doctorId: _doctorId);
    return doctor;
  }

  //キャッシュから医師情報を取得
  Future<Doctor> getDoctorFromCache() async {
    await cacheDoctorList();
    return _doctorInformationCache!.firstWhere((element) {
      return element.doctorId == _doctorId;
    });
  }

  /// 主治医として登録されているリストをキャッシュに保存
  Future<void> cacheDoctorList() async {
    if (PrimaryDoctorsCache().data == null) {
      await _primaryDoctorApi.getPrimaryDoctorList();
      print('主治医リスト取得完了 ${PrimaryDoctorsCache().data}');
    }
  }

  /// 主治医として登録
  Future<void> postPrimaryDoctors() async {
    // 主治医登録APIを実行
    ProtectorNotifier().enableProtector();
    PrimaryDoctorsRequest body = PrimaryDoctorsRequest(doctorId: _doctorId);
    final int response = await _primaryDoctorApi.postPrimaryDoctor(body: body);
    ProtectorNotifier().disableProtector();

    if (response != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    print('主治医登録完了 ${PrimaryDoctorsCache().data}');

    _primary.value = isPrimaryDoctor();
  }

  /// 主治医登録を解除
  Future<void> deletePrimaryDoctors() async {
    // 主治医登録解除APIを実行
    ProtectorNotifier().enableProtector();
    final int response =
        await _primaryDoctorApi.deletePrimaryDoctor(doctorId: _doctorId);
    ProtectorNotifier().disableProtector();

    if (response != 204) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    print('主治医登録解除完了 ${PrimaryDoctorsCache().data}');

    _primary.value = isPrimaryDoctor();
  }

  bool isPrimaryDoctor() {
    print('主 ${PrimaryDoctorsCache().data}');
    if (PrimaryDoctorsCache().data == null) {
      return false;
    }
    return PrimaryDoctorsCache().data!.contains(_doctorId);
  }
}
