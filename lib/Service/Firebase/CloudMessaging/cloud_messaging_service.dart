import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:unicorn_flutter/Constants/Enum/fcm_topic_enum.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class FirebaseCloudMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// 初期化
  Future<void> initialize() async {
    NotificationSettings premission =
        await _firebaseMessaging.requestPermission();

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (premission.authorizationStatus == AuthorizationStatus.authorized) {
      Log.echo('User accepted permission');
    } else {
      Log.echo('User declined permission');
    }
  }

  /// FCMトークンを取得
  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Topicを購読
  Future<void> subscribeToTopics(List<FCMTopicEnum> topics) async {
    for (FCMTopicEnum topic in topics) {
      final String topicName = FCMTopicType.toStringValue(topic);
      await _firebaseMessaging.subscribeToTopic(topicName).then((value) {
        Log.echo('Subscribed to topic: $topicName');
      }).catchError((error) {
        Log.echo('Failed to subscribe to topic: $topicName');
      });
    }
  }
}
