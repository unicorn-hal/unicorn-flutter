import 'package:unicorn_flutter/Model/Entity/AppConfig/app_config.dart';

class AppConfigData {
  static final AppConfigData _instance = AppConfigData._internal();
  factory AppConfigData() => _instance;
  AppConfigData._internal();

  AppConfig _data = AppConfig();

  AppConfig get data => _data;
  bool get demoMode => _data.demoMode;

  void setAppConfig(AppConfig data) {
    _data = data;
  }
}
