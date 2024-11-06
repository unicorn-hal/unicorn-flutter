// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/fcm_topic_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/Account/account_data.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Account/account.dart';
import 'package:unicorn_flutter/Model/Entity/Account/account_request.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Api/Account/account_api.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/Service/Firebase/Authentication/authentication_service.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudMessaging/cloud_messaging_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:unicorn_flutter/Service/Package/SystemInfo/system_info_service.dart';

import '../Model/Data/HealthCheckup/health_checkup_data.dart';
import '../Model/Entity/HealthCheckUp/health_checkup.dart';
import '../Model/Entity/User/user_request.dart';
import '../Service/Api/HealthCheckup/health_checkup_api.dart';

class TopLoadingController extends ControllerCore {
  FirebaseAuthenticationService get _authService =>
      FirebaseAuthenticationService();
  FirebaseCloudMessagingService get _messagingService =>
      FirebaseCloudMessagingService();
  SystemInfoService get _systemInfoService => SystemInfoService();
  AccountApi get _accountApi => AccountApi();
  UserApi get _userApi => UserApi();
  HealthCheckupApi get _healthCheckupApi => HealthCheckupApi();

  BuildContext context;
  TopLoadingController(this.context);

  late String uid;
  String? fcmTokenId = 'debugToken';
  Account? account;
  User? user;

  @override
  void initialize() async {
    /// todo: 初回起動時の処理を記述

    /// Firebase: Cloud Messagingの初期化
    /// tips: 通知のテストを行う場合は、本番環境でのみ実行する
    if (!kDebugMode) {
      await _messagingService.initialize();
      fcmTokenId = await _messagingService.getToken();
      Log.echo('FirebaseCloudMessaging: $fcmTokenId');

      if (fcmTokenId == null) {
        throw Exception('Firebase Cloud Messaging failed');
      }

      /// Firebase: Topicの購読
      await _messagingService.subscribeToTopics(
        <FCMTopicEnum>[
          FCMTopicEnum.all,
          FCMTopicEnum.user,
        ],
      );
    }

    /// ユーザー情報を取得
    firebase_auth.User? authUser = _authService.getUser();
    if (authUser == null) {
      /// Firebase: 匿名ログイン
      firebase_auth.User? credential = await _authService.signInAnonymously();
      if (credential == null) {
        throw Exception('Firebase authentication failed');
      }
      uid = credential.uid;

      /// API: アカウント情報を送信
      account = Account.fromJson({
        'uid': uid,
        'role': 'user',
        'fcmTokenId': fcmTokenId,
      });
      final int statusCode = await _accountApi.postAccount(
        body: AccountRequest.fromJson(account!.toJson()),
      );
      if (statusCode != 200) {
        throw Exception('Account API failed');
      }
    } else {
      uid = authUser.uid;

      /// API: アカウント・ユーザー情報を取得
      account = await _accountApi.getAccount();
      user = await _userApi.getUser(userId: uid);
    }
    Log.toast(
      'FirebaseAuth: ${authUser == null ? '新規' : '登録済み'} ($uid)',
    );
    Log.echo('Account: ${account?.toJson() ?? 'null'}');
    Log.echo('User: ${user?.toJson() ?? 'null'}');

    /// シングルトンにアカウント情報を保存
    AccountData().setAccount(account!);

    /// 検診結果の取得とシングルトンへの保存
    final List<HealthCheckup>? healthCheckup =
        await _healthCheckupApi.getHealthCheckupList();

    print(healthCheckup);

    if (healthCheckup != null) {
      HealthCheckupData().setList(healthCheckup);
    }
    Log.echo('HealthCheckup: ${HealthCheckupData().data}');

    await Future.delayed(const Duration(seconds: 1));

    /// 画面遷移
    // if (user == null) {
    //   const RegisterPhysicalInfoRoute(from: Routes.root).go(context);
    // } else {
    /// シングルトンにユーザー情報を保存
    // UserData().setUser(user!);

    // デバッグ用
    // todo: 本番環境では削除
    await _userApi.postUser(
        body: UserRequest.fromJson({
      'userID': uid,
      'firstName': '太郎',
      'lastName': '山田',
      'email': 'test@test.com',
      'gender': 'male',
      'birthDate': '1990-01-01',
      'address': '東京都新宿区1-1-1',
      'postalCode': '1000001',
      'phoneNumber': '09012345678',
      'iconImageUrl': 'https://placehold.jp/150x150.png',
      'bodyHeight': 180.5,
      'bodyWeight': 75.5,
      'occupation': 'エンジニア',
    }));

    UserData().setUser(User.fromJson({
      'userID': uid,
      'firstName': '太郎',
      'lastName': '山田',
      'email': 'test@test.com',
      'gender': 'male',
      'birthDate': '1990-01-01',
      'address': '東京都新宿区1-1-1',
      'postalCode': '1000001',
      'phoneNumber': '09012345678',
      'iconImageUrl': 'https://placehold.jp/150x150.png',
      'bodyHeight': 180.5,
      'bodyWeight': 75.5,
      'occupation': 'エンジニア',
    }));

    const HomeRoute().go(context);
  }
  // }

  Future<String> get appVersion async {
    final version = await _systemInfoService.appVersion;
    final buildNumber = await _systemInfoService.appBuildNumber;
    return '$version ($buildNumber)';
  }
}
