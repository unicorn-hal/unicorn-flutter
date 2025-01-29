import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unicorn_flutter/Service/Firebase/Authentication/authentication_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:http/http.dart' as http;

class FirebaseCloudMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuthenticationService _authService =
      FirebaseAuthenticationService();
  final String _notificationServerBaseUrl =
      dotenv.env['NOTIFICATION_SERVER_URL'] ?? '';

  /// 初期化
  Future<void> initialize() async {
    NotificationSettings premission =
        await _firebaseMessaging.requestPermission();

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _firebaseMessaging.setAutoInitEnabled(true);

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

  /// NotificationServerアクセス用のヘッダーを作成
  Future<Map<String, String>> _makeHeader() async {
    return <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _authService.getIdToken()}',
    };
  }

  /// Topicを購読
  Future<void> subscribeToTopics(List<String> topics) async {
    for (String topic in topics) {
      http.Response response = await http.post(
        Uri.parse('${_notificationServerBaseUrl}subscribe'),
        headers: await _makeHeader(),
        body: jsonEncode(<String, dynamic>{
          'topic': topic,
          'tokens': [await getToken()],
        }),
      );
      if (response.statusCode == 200) {
        Log.echo('Subscribed to $topic');
      } else {
        Log.echo('Failed to subscribe to $topic');
      }
    }
  }

  /// Topicの購読を解除
  Future<void> unsubscribeFromTopics(List<String> topics) async {
    for (String topic in topics) {
      http.Response response = await http.post(
        Uri.parse('${_notificationServerBaseUrl}unsubscribe'),
        headers: await _makeHeader(),
        body: jsonEncode(<String, dynamic>{
          'topic': topic,
          'tokens': [await getToken()],
        }),
      );
      if (response.statusCode == 200) {
        Log.echo('Unsubscribed from $topic');
      } else {
        Log.echo('Failed to unsubscribe from $topic');
      }
    }
  }
}
