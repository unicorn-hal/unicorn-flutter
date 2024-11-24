import 'package:unicorn_flutter/Service/Package/SharedPreferences/shared_preferences_service.dart';

class LocalAuthController {
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();

  Future<bool> getUseLocalAuth() async {
    return await _sharedPreferencesService.getBool('useLocalAuth') ?? false;
  }

  Future<void> setUseLocalAuth(bool value) async {
    await _sharedPreferencesService.setBool('useLocalAuth', value);
  }
}
