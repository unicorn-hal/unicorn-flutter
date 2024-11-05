import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup.dart';
import 'package:unicorn_flutter/Service/Api/HealthCheckup/health_checkup_api.dart';

class HealthCheckupTopController extends ControllerCore {
  // Serviceのインスタンス化
  HealthCheckupApi get _healthCheckupApi => HealthCheckupApi();

  // コンストラクタ
  HealthCheckupTopController();

  // 変数の定義
  bool? alreadyCheackup;

  // initialize()
  @override
  void initialize() {}

  // 各関数の定義

  // 健康診断結果一覧取得
  Future<List<HealthCheckup>> getHealthCheckupList() async {
    final List<HealthCheckup> healthCheckupList =
        await _healthCheckupApi.getHealthCheckupList() ?? [];
    return healthCheckupList;
  }
}
