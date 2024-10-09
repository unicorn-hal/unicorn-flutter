// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Firebase/Authentication/authentication_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class TopLoadingController {
  FirebaseAuthenticationService get _authService =>
      FirebaseAuthenticationService();

  final BuildContext context;

  TopLoadingController(this.context);

  void firstLoad() async {
    /// todo: 初回起動時の処理を記述

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
