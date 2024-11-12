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
  final String _licenseUrl = '';
  final String _appReviewUrl = '';
  late String _appVersion;

  /// initialize()
  @override
  void initialize() async {
    _appVersion = await getAppVersion();
  }

  /// 各関数の実装
  String get privacyPolicyUrl => _privacyPolicyUrl;
  String get licenseUrl => _licenseUrl;
  String get appReviewUrl => _appReviewUrl;
  String get appVersion => _appVersion;

  /// urlをたたく関数
  Future<void> launchUrl(String url) async {
    await _urlLauncherService.launchUrl(url);
  }

  /// アプリのバージョンを取得する関数
  Future<String> getAppVersion() async {
    return await _systemInfoService.appVersion;
  }
}
