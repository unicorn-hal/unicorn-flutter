import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup.dart';
import 'package:unicorn_flutter/Service/Api/HealthCheckup/health_checkup_api.dart';

import '../../Model/Data/HealthCheckup/health_checkup_data.dart';

class HealthCheckupTopController extends ControllerCore {
  // Serviceのインスタンス化
  HealthCheckupApi get _healthCheckupApi => HealthCheckupApi();

  // コンストラクタ
  HealthCheckupTopController();

  // 変数の定義
  late bool alreadyCheackup;

  // initialize()
  @override
  void initialize() {
    alreadyCheackup = checkTodayHealthCheckup();
  }

  // 本日の健康診断が登録されているか確認
  bool checkTodayHealthCheckup() {
    // データがnullの場合はfalseを返す
    if (HealthCheckupData().data == null) return false;

    // 本日の日付をDateTime方で取得(2024-11-06の形式)
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 本日の日付で健康診断がシングルトンに格納されているか確認
    final bool result = HealthCheckupData().data!.any((element) {
      final HealthCheckup healthCheckup = element;
      final String date = DateFormat('yyyy-MM-dd').format(healthCheckup.date);
      return date == today;
    });

    return result;
  }
}
