import 'package:unicorn_flutter/Model/Cache/Doctor/Information/doctor_information_cache.dart';
import 'package:unicorn_flutter/Model/Entity/PrimaryDoctor/primary_doctors_request.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';
import 'package:unicorn_flutter/Service/Api/PrimaryDoctor/primary_doctor_api.dart';

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

  @override
  void initialize() {
    _doctorInformationCache = DoctorInformationCache().data;
    _exist = _checkExist();
  }

  bool get exist => _exist;

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
    PrimaryDoctorsRequest body = PrimaryDoctorsRequest(doctorIds: [_doctorId]);
    final int response = await _primaryDoctorApi.postPrimaryDoctors(body: body);
    print(response);
  }
}
