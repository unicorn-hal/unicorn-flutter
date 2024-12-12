import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Cache/HealthCheckup/health_checkup_cache.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_request.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';

class EmergencyResultController extends ControllerCore {
  UserApi get _userApi => UserApi();

  EmergencyResultController({
    required this.bodyTemperature,
    required this.bloodPressure,
  });
  final double bodyTemperature;
  final String bloodPressure;

  @override
  void initialize() {
    _updateHealthCheckup();
  }

  Future<void> _updateHealthCheckup() async {
    HealthCheckup? headlthCheckupData = HealthCheckupCache().getTodayData();
    if (headlthCheckupData == null) {
      return;
    }
    String medicalRecord = headlthCheckupData.medicalRecord;
    String addMedicalRecord = '## Unicorn緊急要請\n'
        '体温: $bodyTemperature℃\n'
        '血圧: $bloodPressure\n'
        'Unicornが緊急要請を受け、対応を行いました。\n';

    final res = await _userApi.putUserHealthCheckup(
      userId: UserData().user!.userId,
      healthCheckupId: headlthCheckupData.healthCheckupId,
      body: HealthCheckupRequest(
        bodyTemperature: bodyTemperature,
        bloodPressure: bloodPressure,
        date: headlthCheckupData.date,
        medicalRecord: '$medicalRecord\n$addMedicalRecord',
      ),
    );
    if (res != 200) {
      Fluttertoast.showToast(msg: '検診結果の更新に失敗しました。');
      return;
    }
    Fluttertoast.showToast(msg: '検診結果を更新しました。');
  }
}
