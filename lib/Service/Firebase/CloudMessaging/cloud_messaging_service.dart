import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class FirebaseCloudMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    NotificationSettings premission =
        await _firebaseMessaging.requestPermission();

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
}
