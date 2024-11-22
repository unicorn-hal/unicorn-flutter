import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/fcm_topic_enum.dart';
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
  NotificationSettingController(this._userNotification);
  UserNotification _userNotification;

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装
  UserNotification? get userNotification => _userNotification;

  void setMedicineNotificationValue(bool value) {
    _userNotification = UserNotification(
      isHospitalNews: _userNotification.isHospitalNews,
      isMedicineReminder: value,
      isRegularHealthCheckup: _userNotification.isRegularHealthCheckup,
    );
  }

  void setHealthCheckupValue(bool value) {
    _userNotification = UserNotification(
      isHospitalNews: _userNotification.isHospitalNews,
      isMedicineReminder: _userNotification.isMedicineReminder,
      isRegularHealthCheckup: value,
    );
  }

  void setHospitalNotificationValue(bool value) {
    _userNotification = UserNotification(
      isHospitalNews: value,
      isMedicineReminder: _userNotification.isMedicineReminder,
      isRegularHealthCheckup: _userNotification.isRegularHealthCheckup,
    );
  }

  /// 通知設定を更新する関数
  Future<void> putUserNotification() async {
    ProtectorNotifier().enableProtector();
    int res = await _userApi.putUserNotification(
        userId: UserData().user!.userId, body: _userNotification);
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      ProtectorNotifier().disableProtector();
      return;
    }
    await updateSubscription(
      isSubscribed: _userNotification.isRegularHealthCheckup,
      topics: [FCMTopicEnum.regularHealthCheckup.name],
    );
    await updateSubscription(
      isSubscribed: _userNotification.isHospitalNews,
      topics: [FCMTopicEnum.hospitalNews.name],
    );
    Fluttertoast.showToast(msg: Strings.SETTING_REFLECTED_TEXT);
    ProtectorNotifier().disableProtector();
  }

  /// 通知設定を登録する関数
  Future<void> postUserNotification() async {
    ProtectorNotifier().enableProtector();
    int res = await _userApi.postUserNotification(
        userId: UserData().user!.userId, body: _userNotification);
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      ProtectorNotifier().disableProtector();
      return;
    }
    await updateSubscription(
      isSubscribed: _userNotification.isRegularHealthCheckup,
      topics: [FCMTopicEnum.regularHealthCheckup.name],
    );
    await updateSubscription(
      isSubscribed: _userNotification.isHospitalNews,
      topics: [FCMTopicEnum.hospitalNews.name],
    );
    Fluttertoast.showToast(msg: Strings.SETTING_REFLECTED_TEXT);
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
