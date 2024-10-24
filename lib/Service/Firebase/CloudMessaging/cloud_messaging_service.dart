import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unicorn_flutter/Constants/Enum/fcm_topic_enum.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:http/http.dart' as http;

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

  /// Topicを購読
  Future<void> subscribeToTopics(List<FCMTopicEnum> topics) async {
    final String messagingApiBaseUrl =
        dotenv.env['MESSAGING_API_BASEURL'] ?? '';
    for (FCMTopicEnum topic in topics) {
      final String topicName = FCMTopicType.toStringValue(topic);
      http.Response response = await http.post(
        Uri.parse('${messagingApiBaseUrl}subscribe'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'topic': topicName,
          'tokens': [await getToken()],
        }),
      );
      if (response.statusCode == 200) {
        Log.echo('Subscribed to $topicName');
      } else {
        Log.echo('Failed to subscribe to $topicName');
      }
    }
  }
}
