import 'package:unicorn_flutter/Model/Data/AppConfig/app_config.dart';

class AppConfigData {
  static final AppConfigData _instance = AppConfigData._internal();
  factory AppConfigData() => _instance;
  AppConfigData._internal();

  AppConfig? _available;

  AppConfig? get available => _available;

  void setAppConfig(AppConfig available) {
    _available = available;
  }
}
