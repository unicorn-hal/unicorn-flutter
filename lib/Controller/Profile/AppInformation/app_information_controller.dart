import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Service/Package/SystemInfo/system_info_service.dart';
import 'package:unicorn_flutter/Service/Package/UrlLauncher/url_launcher_service.dart';

class AppInformationController extends ControllerCore {
  /// Serviceのインスタンス化
  UrlLauncherService get _urlLauncherService => UrlLauncherService();
  SystemInfoService get _systemInfoService => SystemInfoService();

  /// 変数の定義
  // todo: url決まったら入れる
  final String _privacyPolicyUrl = '';

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装
  String get privacyPolicyUrl => _privacyPolicyUrl;

  /// urlをたたく関数
  Future<void> launchUrl(String url) async {
    await _urlLauncherService.launchUrl(url);
  }

  /// アプリのバージョンを取得する関数
  Future<String> getAppVersion() async {
    return await _systemInfoService.appVersion;
  }

  /// アプリのレビューページに飛ばす関数
  Future<void> openReview() async {
    await _systemInfoService.openReview();
  }
}
