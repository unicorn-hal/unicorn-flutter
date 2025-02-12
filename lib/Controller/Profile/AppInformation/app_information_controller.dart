import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Api/Account/account_api.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/SharedPreferences/shared_preferences_service.dart';
import 'package:unicorn_flutter/Service/Package/SystemInfo/system_info_service.dart';
import 'package:unicorn_flutter/Service/Package/UrlLauncher/url_launcher_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class AppInformationController extends ControllerCore {
  /// Serviceのインスタンス化
  UrlLauncherService get _urlLauncherService => UrlLauncherService();
  SystemInfoService get _systemInfoService => SystemInfoService();
  UserApi get _userApi => UserApi();
  AccountApi get _accountApi => AccountApi();

  SharedPreferencesService get _sharedPreferencesService =>
      SharedPreferencesService();

  /// 変数の定義
  final String _privacyPolicyUrl =
      'https://unicorn-hal.github.io/unicorn-privacy-policy/';

  BuildContext context;
  AppInformationController(this.context);

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装
  String get privacyPolicyUrl => _privacyPolicyUrl;

  /// アプリのバージョンを取得する関数
  Future<String> getAppVersion() async {
    return await _systemInfoService.appVersion;
  }

  /// アプリのレビューページに飛ばす関数
  Future<void> openReview() async {
    await _systemInfoService.openReview();
  }

  /// プライバシーポリシー
  Future<void> openPrivacyPolicy() async {
    await _urlLauncherService.launchUrl(_privacyPolicyUrl);
  }

  /// 退会処理
  Future<void> unsubscribe() async {
    try {
      ProtectorNotifier().enableProtector();
      await _userApi.deleteUser(userId: UserData().user!.userId);
      await _accountApi.deleteAccount();
      await _sharedPreferencesService.clear();
      // ignore: use_build_context_synchronously
      const SignOutRoute().go(context);
    } catch (e) {
      Log.echo('unsubscribe error: $e');
    } finally {
      ProtectorNotifier().disableProtector();
    }
  }
}
