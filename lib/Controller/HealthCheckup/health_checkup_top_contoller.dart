import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup.dart';

import '../../Model/Data/HealthCheckup/health_checkup_data.dart';

class HealthCheckupTopController extends ControllerCore {
  // コンストラクタ
  HealthCheckupTopController();

  // 変数の定義
  late String today;
  late bool alreadyCheackup;
  late HealthCheckup todayHealthCheckup;

  // initialize()
  @override
  void initialize() {
    // 本日の日付をDateTime方で取得(2024-11-06の形式)
    today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    alreadyCheackup = checkTodayHealthCheckup();
    if (alreadyCheackup) {
      todayHealthCheckup = getTodayHealthCheckup();
    }
  }

  // 本日の健康診断が登録されているかを確認
  bool checkTodayHealthCheckup() {
    // データがnullの場合はfalseを返す
    if (HealthCheckupData().data == null) return false;
    // 本日の日付で健康診断がシングルトンに格納されているか確認
    final bool result = HealthCheckupData().data!.any((element) {
      final HealthCheckup healthCheckup = element;
      final String date = DateFormat('yyyy-MM-dd').format(healthCheckup.date);
      return date == today;
    });
    return result;
  }

  // 本日の健康診断を取得
  HealthCheckup getTodayHealthCheckup() {
    // 本日の日付で健康診断がシングルトンに格納されているか確認
    final HealthCheckup todayHealthCheckup =
        HealthCheckupData().data!.firstWhere((element) {
      final HealthCheckup healthCheckup = element;
      final String date = DateFormat('yyyy-MM-dd').format(healthCheckup.date);
      return date == today;
    });
    return todayHealthCheckup;
  }
}
