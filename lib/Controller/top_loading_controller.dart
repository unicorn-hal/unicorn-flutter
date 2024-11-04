// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/fcm_topic_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Firebase/Authentication/authentication_service.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudMessaging/cloud_messaging_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class TopLoadingController extends ControllerCore {
  FirebaseAuthenticationService get _authService =>
      FirebaseAuthenticationService();
  FirebaseCloudMessagingService get _messagingService =>
      FirebaseCloudMessagingService();

  BuildContext context;
  TopLoadingController(this.context);

  @override
  void initialize() async {
    /// todo: 初回起動時の処理を記述

    /// Firebase: Cloud Messagingの初期化
    /// tips: 通知のテストを行う場合は、本番環境でのみ実行する
    if (!kDebugMode) {
      await _messagingService.initialize();
      final String? token = await _messagingService.getToken();
      Log.echo('FirebaseCloudMessaging: $token');
      // todo: トークンをサーバーに送信

      /// Firebase: Topicの購読
      await _messagingService.subscribeToTopics(
        <FCMTopicEnum>[
          FCMTopicEnum.all,
          FCMTopicEnum.user,
        ],
      );
    }

    /// todo: UserEntityが配置されてから、ユーザー固有情報をAPIから取得する
    /// ユーザー情報を取得
    firebase_auth.User? authUser = _authService.getUser();
    if (authUser == null) {
      /// Firebase: 匿名ログイン
      firebase_auth.User? credential = await _authService.signInAnonymously();
      if (credential == null) {
        throw Exception('Firebase authentication failed');
      }
    }
    Log.toast(
      'FirebaseAuth: ${authUser == null ? '新規' : '登録済み'} (${_authService.getUid()})',
    );

    Log.echo('TopLoadingController: firstLoad', symbol: '🔍');
    await Future.delayed(const Duration(seconds: 1));
    const HomeRoute().go(context);
  }
}
