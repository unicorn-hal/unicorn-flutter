import 'package:unicorn_flutter/Model/Data/AppConfig/app_config.dart';

class AppConfigData {
  static final AppConfigData _instance = AppConfigData._internal();
  factory AppConfigData() => _instance;
  AppConfigData._internal();

  AppConfig? _data;

  AppConfig? get data => _data;

  void setAppConfig(AppConfig data) {
    _data = data;
  }
}
