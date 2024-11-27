// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/fcm_topic_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/shared_preferences_keys_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/Account/account_data.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Account/account.dart';
import 'package:unicorn_flutter/Model/Entity/Account/account_request.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat.dart';
import 'package:unicorn_flutter/Model/Entity/Department/department.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Api/Account/account_api.dart';
import 'package:unicorn_flutter/Service/Api/Chat/chat_api.dart';
import 'package:unicorn_flutter/Service/Api/Department/department_api.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/Service/Firebase/Authentication/authentication_service.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudMessaging/cloud_messaging_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:unicorn_flutter/Service/Package/LocalAuth/local_auth_service.dart';
import 'package:unicorn_flutter/Service/Package/SharedPreferences/shared_preferences_service.dart';
import 'package:unicorn_flutter/Service/Package/SystemInfo/system_info_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';

import '../Model/Chat/chat_data.dart';
import '../Model/Data/Department/department_data.dart';
import '../Model/Data/HealthCheckup/health_checkup_data.dart';
import '../Model/Entity/HealthCheckUp/health_checkup.dart';
import '../Model/Entity/User/user_request.dart';

class TopLoadingController extends ControllerCore {
  SharedPreferencesService get _sharedPreferencesService =>
      SharedPreferencesService();
  FirebaseAuthenticationService get _authService =>
      FirebaseAuthenticationService();
  FirebaseCloudMessagingService get _messagingService =>
      FirebaseCloudMessagingService();
  SystemInfoService get _systemInfoService => SystemInfoService();
  AccountApi get _accountApi => AccountApi();
  UserApi get _userApi => UserApi();
  ChatApi get _chatApi => ChatApi();
  DepartmentApi get _departmentApi => DepartmentApi();
  LocalAuthService get _localAuthService => LocalAuthService();

  BuildContext context;
  TopLoadingController(this.context);

  late String uid;
  String? fcmTokenId = 'debugToken';
  Account? account;
  User? user;

  @override
  void initialize() async {
    /// todo: 初回起動時の処理を記述

    /// SharedPreferences: 起動フラグを確認
    bool? appInitialized = await _sharedPreferencesService
        .getBool(SharedPreferencesKeysEnum.appInitialized.name);

    /// SharedPreferences: useLocalAuth フラグを初回起動時に設定
    if (appInitialized == null || appInitialized == false) {
      await _sharedPreferencesService.setBool(
          SharedPreferencesKeysEnum.useLocalAuth.name, false);
    }

    /// useLocalAuth フラグが有効なら認証を行う
    bool useLocalAuth = await _sharedPreferencesService
            .getBool(SharedPreferencesKeysEnum.useLocalAuth.name) ??
        false;

    /// ローカル認証
    Completer localAuthCompleter = Completer<void>();
    await _checkLocalAuth(useLocalAuth, localAuthCompleter);

    /// ユーザー情報を取得
    firebase_auth.User? authUser = _authService.getUser();
    if (authUser == null) {
      /// Firebase: 匿名ログイン
      firebase_auth.User? credential = await _authService.signInAnonymously();
      if (credential == null) {
        throw Exception('Firebase authentication failed');
      }
      uid = credential.uid;

      /// Firebase: FCMトークンを取得
      await _cloudMessagingInitialize();

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

      /// 起動フラグが立っていない場合はTokenの再取得
      if (appInitialized == false || appInitialized == null) {
        /// Firebase: FCMトークンを取得
        await _cloudMessagingInitialize();

        /// API: アカウント情報を更新
        final int statusCode = await _accountApi.putAccount(
          fcmTokenId: fcmTokenId!,
        );
        if (statusCode != 200) {
          throw Exception('Account API failed');
        }
      }

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

    // 診療科一覧を取得してデータクラスに保存
    final List<Department>? departmentList =
        await _departmentApi.getDepartmentList();

    if (departmentList != null) {
      DepartmentData().setDepartment(departmentList);
      Log.echo('Department: ${departmentList.map((e) => e.toJson()).toList()}');
    }

    /// 検診結果の取得とシングルトンへの保存
    final List<HealthCheckup>? healthCheckup =
        await _userApi.getUserHealthCheckupList(userId: uid);

    if (healthCheckup != null) {
      HealthCheckupData().setList(healthCheckup);
    }
    Log.echo('HealthCheckup: ${HealthCheckupData().data}');

    await Future.delayed(const Duration(seconds: 1));

    /// 画面遷移
    // if (user == null) {
    //   _sharedPreferencesService.setBool(
    //       SharedPreferencesKeysEnum.appInitialized.name, true);
    //   const RegisterPhysicalInfoRoute(from: Routes.root).go(context);
    // } else {
    /// シングルトンにユーザー情報を保存
    // UserData().setUser(user!);

    // チャット情報を取得してデータクラスに保存
    final List<Chat>? chatList = await _chatApi.getChatList();
    if (chatList != null) {
      ChatData().setChat(chatList);
      Log.echo('Chat: ${chatList.map((e) => e.toJson()).toList()}');
    }

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

    /// SharedPreferences: 起動フラグ
    _sharedPreferencesService.setBool(
        SharedPreferencesKeysEnum.appInitialized.name, true);

    const HomeRoute().go(context);
  }

  Future<String> get appVersion async {
    final version = await _systemInfoService.appVersion;
    final buildNumber = await _systemInfoService.appBuildNumber;
    return '$version ($buildNumber)';
  }

  /// Firebase Cloud Messagingの初期化
  Future<void> _cloudMessagingInitialize() async {
    /// tips: デバッグモードの場合はFirebase Cloud Messagingを初期化しない
    if (!kDebugMode) {
      await _messagingService.initialize();
      fcmTokenId = await _messagingService.getToken();
      Log.echo('FirebaseCloudMessaging: $fcmTokenId');

      if (fcmTokenId == null) {
        throw Exception('Firebase Cloud Messaging failed');
      }

      await _messagingService.subscribeToTopics(
        <String>[
          FCMTopicEnum.all.name,
          FCMTopicEnum.user.name,
        ],
      );
    }
  }

  /// ローカル認証
  /// [useLocalAuth] ローカル認証を行うかどうか
  /// [completer] 認証完了時に呼び出すCompleter
  Future<void> _checkLocalAuth(bool useLocalAuth, Completer completer) async {
    if (useLocalAuth) {
      // 認証処理を追加
      try {
        bool? isAuthenticated = await _localAuthService.authenticate();
        if (isAuthenticated == null) {
          isAuthenticated = true;
        } else if (!isAuthenticated) {
          if (!context.mounted) {
            return;
          }
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                  title: '認証に失敗しました',
                  bodyText: '再度認証を行ってください',
                  leftButtonText: 'もう一度行う',
                  customButtonCount: 1,
                  leftButtonOnTap: () {
                    _checkLocalAuth(useLocalAuth, completer);
                  },
                );
              });
          await completer.future;
        } else {
          completer.complete();
        }
      } catch (e) {
        Log.echo('Error: $e');
        await completer.future;
      }
    }
  }
}
