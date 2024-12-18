import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_result_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup.dart';

import '../../Model/Cache/HealthCheckup/health_checkup_cache.dart';

class HealthCheckupTopController extends ControllerCore {
  // コンストラクタ
  HealthCheckupTopController();

  // initialize()
  @override
  void initialize() {}

  // 健康診断のデータに今日の日付のデータがあるか確認
  HealthCheckup? getTodayHealthCheckup() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // 本日の日付で健康診断がシングルトンに格納されているか確認
    HealthCheckup? todayHealthCheckup;
    try {
      todayHealthCheckup = HealthCheckupCache().data.firstWhere(
        (element) {
          final HealthCheckup healthCheckup = element;
          final String date =
              DateFormat('yyyy-MM-dd').format(healthCheckup.date);
          return date == today;
        },
      );
      return todayHealthCheckup;
    } catch (e) {
      return null;
    }
  }

  // 本日の健康診断結果からEnumを取得
  HealthCheckupResultEnum resultToEnum(HealthCheckup result) {
    // 本日の健康診断が登録されている場合は体温と血圧の結果を取得
    final double bodyTemperature = result.bodyTemperature;

    /// 血圧の値を取得
    /// 血圧の値は「収縮期血圧/拡張期血圧」の形式で格納されているため、
    final double systolicBloodPressure =
        double.parse(result.bloodPressure.split('/').first);
    final double diastolicBloodPressure =
        double.parse(result.bloodPressure.split('/').last);

    // 体温と血圧の結果を元に健康診断結果を取得
    if (bodyTemperature >= 36.0 && bodyTemperature <= 37.5) {
      if (systolicBloodPressure >= 95.0 && systolicBloodPressure <= 115.0) {
        if (diastolicBloodPressure >= 55.0 && diastolicBloodPressure <= 78.0) {
          return HealthCheckupResultEnum.safety;
        }
        return HealthCheckupResultEnum.bloodPressureHazard;
      }
      return HealthCheckupResultEnum.bodyTemperatureHazard;
    }
    return HealthCheckupResultEnum.danger;
  }
}
