import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_notification.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudMessaging/cloud_messaging_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class NotificationSettingController extends ControllerCore {
  /// Serviceのインスタンス化
  UserApi get _userApi => UserApi();
  FirebaseCloudMessagingService get _firebaseCloudMessagingService =>
      FirebaseCloudMessagingService();

  /// コンストラクタ
  NotificationSettingController();

  /// 変数の定義
  UserNotification? _userNotification;
  ValueNotifier<UserNotification> _formatedUserNotification = ValueNotifier(
    UserNotification(
      isHospitalNews: true,
      isMedicineReminder: true,
      isRegularHealthCheckup: true,
    ),
  );

  /// initialize()
  @override
  void initialize() async {
    await getUserNotification();
    ProtectorNotifier().disableProtector();
  }

  /// 各関数の実装
  UserNotification? get userNotification => _userNotification;
  ValueNotifier<UserNotification> get formatedUserNotification =>
      _formatedUserNotification;

  void setMedicineNotificationValue(bool value) {
    _formatedUserNotification = ValueNotifier(
      UserNotification(
        isHospitalNews: _formatedUserNotification.value.isHospitalNews,
        isMedicineReminder: value,
        isRegularHealthCheckup:
            _formatedUserNotification.value.isRegularHealthCheckup,
      ),
    );
  }

  void setHealthCheckupValue(bool value) {
    _formatedUserNotification = ValueNotifier(
      UserNotification(
        isHospitalNews: _formatedUserNotification.value.isHospitalNews,
        isMedicineReminder: _formatedUserNotification.value.isMedicineReminder,
        isRegularHealthCheckup: value,
      ),
    );
  }

  void setHospitalNotificationValue(bool value) {
    _formatedUserNotification = ValueNotifier(
      UserNotification(
        isHospitalNews: value,
        isMedicineReminder: _formatedUserNotification.value.isMedicineReminder,
        isRegularHealthCheckup:
            _formatedUserNotification.value.isRegularHealthCheckup,
      ),
    );
  }

  /// 通知設定を取得する関数
  Future<void> getUserNotification() async {
    _userNotification =
        await _userApi.getUserNotification(userId: UserData().user!.userId);
    if (_userNotification == null) {
      return;
    }
    _formatedUserNotification.value = _userNotification!;
  }

  /// 通知設定を更新する関数
  Future<void> putUserNotification() async {
    ProtectorNotifier().enableProtector();
    int res = await _userApi.putUserNotification(
      userId: UserData().user!.userId,
      body: UserNotification(
        isHospitalNews: _formatedUserNotification.value.isHospitalNews,
        isMedicineReminder: _formatedUserNotification.value.isMedicineReminder,
        isRegularHealthCheckup:
            _formatedUserNotification.value.isRegularHealthCheckup,
      ),
    );
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      ProtectorNotifier().disableProtector();
      return;
    }
    await updateSubscription(
      isSubscribed: _formatedUserNotification.value.isRegularHealthCheckup,
      topics: ['regularHealthCheckup'],
    );
    await updateSubscription(
      isSubscribed: _formatedUserNotification.value.isHospitalNews,
      topics: ['hospitalNews'],
    );
    Fluttertoast.showToast(msg: '設定を反映しました');
    ProtectorNotifier().disableProtector();
  }

  /// 通知設定を登録する関数
  Future<void> postUserNotification() async {
    ProtectorNotifier().enableProtector();
    int res = await _userApi.postUserNotification(
      userId: UserData().user!.userId,
      body: UserNotification(
        isHospitalNews: _formatedUserNotification.value.isHospitalNews,
        isMedicineReminder: _formatedUserNotification.value.isMedicineReminder,
        isRegularHealthCheckup:
            _formatedUserNotification.value.isRegularHealthCheckup,
      ),
    );
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      ProtectorNotifier().disableProtector();
      return;
    }
    await updateSubscription(
      isSubscribed: _formatedUserNotification.value.isRegularHealthCheckup,
      topics: ['regularHealthCheckup'],
    );
    await updateSubscription(
      isSubscribed: _formatedUserNotification.value.isHospitalNews,
      topics: ['hospitalNews'],
    );
    Fluttertoast.showToast(msg: '設定を反映しました');
    ProtectorNotifier().disableProtector();
  }

  /// 実際にSubscriptionの購読の有無を更新する関数
  Future<void> updateSubscription({
    required bool isSubscribed,
    required List<String> topics,
  }) async {
    /// topics : ['regularHealthCheckup'],['hospitalNews']
    isSubscribed
        ? await _firebaseCloudMessagingService.subscribeToTopics(topics)
        : await _firebaseCloudMessagingService.unsubscribeFromTopics(topics);
  }
}
