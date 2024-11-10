import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_result_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup.dart';

import '../../Model/Data/HealthCheckup/health_checkup_data.dart';

class HealthCheckupTopController extends ControllerCore {
  // コンストラクタ
  HealthCheckupTopController();

  // 変数の定義
  late String _today;
  late bool _alreadyCheackup;

  HealthCheckup? _todayHealthCheckup;
  HealthCheckupResultEnum? _healthCheckupResult;

  // initialize()
  @override
  void initialize() {
    // 本日の日付をDateTime方で取得(2024-11-06の形式)
    _today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    _alreadyCheackup = _checkTodayHealthCheckup();

    // 本日の健康診断が登録されている場合の処理
    if (_alreadyCheackup) {
      _todayHealthCheckup = _getTodayHealthCheckup();
      _healthCheckupResult = _resultToEnum(_todayHealthCheckup!);
    }
  }

  // 本日の健康診断が登録されているかを確認
  bool _checkTodayHealthCheckup() {
    // データがnullの場合はfalseを返す
    if (HealthCheckupData().data == null) return false;
    // 本日の日付で健康診断がシングルトンに格納されているか確認
    final bool result = HealthCheckupData().data!.any((element) {
      final HealthCheckup healthCheckup = element;
      final String date = DateFormat('yyyy-MM-dd').format(healthCheckup.date);
      return date == _today;
    });
    return result;
  }

  bool get alreadyCheackup => _alreadyCheackup;

  // 本日の健康診断を取得
  HealthCheckup _getTodayHealthCheckup() {
    // 本日の日付で健康診断がシングルトンに格納されているか確認
    final HealthCheckup todayHealthCheckup =
        HealthCheckupData().data!.firstWhere((element) {
      final HealthCheckup healthCheckup = element;
      final String date = DateFormat('yyyy-MM-dd').format(healthCheckup.date);
      return date == _today;
    });
    return todayHealthCheckup;
  }

  HealthCheckup get todayHealthCheckup => _todayHealthCheckup!;

  // 本日の健康診断結果からEnumを取得
  HealthCheckupResultEnum _resultToEnum(HealthCheckup result) {
    // 本日の健康診断が登録されている場合は体温と血圧の結果を取得
    final double bodyTemperature = result.bodyTemperature;
    final double bloodPressurehight =
        double.parse(result.bloodPressure.split('/').first);
    final double bloodPressureLow =
        double.parse(result.bloodPressure.split('/').last);

    // 体温と血圧の結果を元に健康診断結果を取得
    if (bodyTemperature >= 36.0 && bodyTemperature <= 37.5) {
      if (bloodPressureLow >= 80.0 && bloodPressurehight <= 120.0) {
        return HealthCheckupResultEnum.safety;
      } else {
        return HealthCheckupResultEnum.bloodPressureHazard;
      }
    } else {
      if (bloodPressureLow >= 80.0 && bloodPressurehight <= 120.0) {
        return HealthCheckupResultEnum.bodyTemperatureHazard;
      } else {
        return HealthCheckupResultEnum.danger;
      }
    }
  }

  HealthCheckupResultEnum get healthCheckupResult => _healthCheckupResult!;
}
