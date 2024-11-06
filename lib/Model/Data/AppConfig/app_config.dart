class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  bool? _available;

  bool? get available => _available;

  void setAppConfig(bool available) {
    _available = available;
  }
}
