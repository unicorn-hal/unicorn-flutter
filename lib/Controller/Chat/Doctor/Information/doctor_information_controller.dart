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
  late bool _primary;

  @override
  void initialize() {
    _doctorInformationCache = DoctorInformationCache().data;
    _exist = _checkExist();
    _primary = PrimaryDoctorsCache().isPrimaryDoctor(_doctorId);
  }

  bool get exist => _exist;
  bool get primary => _primary;

  // キャッシュしたデータの中に指定したIDの医師情報があるかを確認
  bool _checkExist() {
    return _doctorInformationCache!
        .any((element) => element.doctorId == _doctorId);
  }

  // APIで医師情報を取得
  Future<Doctor?> getDoctor() async {
    final Doctor? doctor = await _doctorApi.getDoctor(doctorId: _doctorId);
    return doctor;
  }

  //キャッシュから医師情報を取得
  Future<Doctor> getDoctorFromCache() async {
    return _doctorInformationCache!.firstWhere((element) {
      return element.doctorId == _doctorId;
    });
  }

  /// 主治医として登録
  Future<void> postPrimaryDoctor() async {
    // 主治医登録APIを実行
    ProtectorNotifier().enableProtector();
    PrimaryDoctorsRequest body = PrimaryDoctorsRequest(doctorId: _doctorId);
    final int response = await _primaryDoctorApi.postPrimaryDoctor(body: body);
    ProtectorNotifier().disableProtector();

    if (response != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      return;
    }
    // 成功時のトースト表示
    Fluttertoast.showToast(msg: Strings.SUCCESS_PRIMARY_DOCTOR_TEXT);
  }

  /// 主治医登録を解除
  Future<void> deletePrimaryDoctor() async {
    // 主治医登録解除APIを実行
    ProtectorNotifier().enableProtector();
    final int response =
        await _primaryDoctorApi.deletePrimaryDoctor(doctorId: _doctorId);
    ProtectorNotifier().disableProtector();

    if (response != 204) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      return;
    }
    // 成功時のトースト表示
    Fluttertoast.showToast(msg: Strings.SUCCESS_DELETE_PRIMARY_DOCTOR_TEXT);
  }
}
