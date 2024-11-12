import 'package:unicorn_flutter/Controller/Core/controller_core.dart';

class NotificationSettingController extends ControllerCore {
  /// Serviceのインスタンス化

  /// コンストラクタ
  NotificationSettingController();

  /// 変数の定義
  bool _medicineNotificationValue = false;
  bool _healthCheckupValue = false;
  bool _hospitalNotificationValue = false;

  /// initialize()
  @override
  void initialize() {
    print('Controller Init');
  }

  /// 各関数の実装
  bool get medicineNotificationValue => _medicineNotificationValue;
  void setmedicineNotificationValue(bool value) {
    _medicineNotificationValue = value;
  }

  bool get healthCheckupValue => _healthCheckupValue;
  void sethealthCheckupValue(bool value) {
    _healthCheckupValue = value;
  }

  bool get hospitalNotificationValue => _hospitalNotificationValue;
  void sethospitalNotificationValue(bool value) {
    _hospitalNotificationValue = value;
  }
}
