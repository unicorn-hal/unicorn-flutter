import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_notification.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class NotificationSettingController extends ControllerCore {
  /// Serviceのインスタンス化
  UserApi get _userApi => UserApi();

  /// コンストラクタ
  NotificationSettingController();

  /// 変数の定義
  bool _medicineNotificationValue = false;
  bool _healthCheckupValue = false;
  bool _hospitalNotificationValue = false;
  UserNotification? _userNotification;

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装
  UserNotification? get userNotification => _userNotification;

  bool get medicineNotificationValue => _medicineNotificationValue;
  void setMedicineNotificationValue(bool value) {
    _medicineNotificationValue = value;
  }

  bool get healthCheckupValue => _healthCheckupValue;
  void setHealthCheckupValue(bool value) {
    _healthCheckupValue = value;
  }

  bool get hospitalNotificationValue => _hospitalNotificationValue;
  void setHospitalNotificationValue(bool value) {
    _hospitalNotificationValue = value;
  }

  Future<void> getUserNotification() async {
    _userNotification =
        await _userApi.getUserNotification(userId: UserData().user!.userId);
    if (_userNotification == null) {
      return;
    }
    setHealthCheckupValue(_userNotification!.isRegularHealthCheckup);
    setHospitalNotificationValue(_userNotification!.isHospitalNews);
    setMedicineNotificationValue(_userNotification!.isMedicineReminder);
  }

  Future<void> putUserNotification() async {
    ProtectorNotifier().enableProtector();
    int res = await _userApi.putUserNotification(
      userId: UserData().user!.userId,
      body: UserNotification(
        isHospitalNews: _hospitalNotificationValue,
        isMedicineReminder: _medicineNotificationValue,
        isRegularHealthCheckup: _healthCheckupValue,
      ),
    );
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    Fluttertoast.showToast(msg: '設定を反映しました');
    ProtectorNotifier().disableProtector();
  }

  Future<void> postUserNotification() async {
    ProtectorNotifier().enableProtector();
    int res = await _userApi.postUserNotification(
      userId: UserData().user!.userId,
      body: UserNotification(
        isHospitalNews: _hospitalNotificationValue,
        isMedicineReminder: _medicineNotificationValue,
        isRegularHealthCheckup: _healthCheckupValue,
      ),
    );
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    Fluttertoast.showToast(msg: '設定を反映しました');
    ProtectorNotifier().disableProtector();
  }
}
