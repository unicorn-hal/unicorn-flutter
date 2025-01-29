import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/shared_preferences_keys_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Package/LocalAuth/local_auth_service.dart';
import 'package:unicorn_flutter/Service/Package/SharedPreferences/shared_preferences_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class LocalAuthController extends ControllerCore {
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  final LocalAuthService _localAuthService = LocalAuthService();

  bool _useAppbar = false;
  bool useLocalAuth = true;

  LocalAuthController({required super.from});

  @override
  void initialize() {
    if (from == Routes.profile) {
      _useAppbar = true;
    }
  }

  bool get useAppbar => _useAppbar;

  Future<bool> _getUseLocalAuth() async {
    return await _sharedPreferencesService
            .getBool(SharedPreferencesKeysEnum.useLocalAuth.name) ??
        false;
  }

  Future<void> _setUseLocalAuth(bool value) async {
    await _sharedPreferencesService.setBool(
        SharedPreferencesKeysEnum.useLocalAuth.name, value);
  }

  Future<void> loadUseLocalAuth(Function(bool) callback) async {
    bool useLocalAuth = await _getUseLocalAuth();
    callback(useLocalAuth);
  }

  Future<void> updateUseLocalAuth(bool value, Function(bool) callback) async {
    await _setUseLocalAuth(value);
    callback(value);
  }

  Future<bool> checkLocalAuth(BuildContext context, bool useLocalAuth) async {
    if (useLocalAuth) {
      bool isAuthenticated = false;
      try {
        isAuthenticated = await _localAuthService.authenticate() ?? false;
      } catch (error) {
        Log.toast('Local Authentication failed');
        await _setUseLocalAuth(false);
      }

      if (!isAuthenticated) {
        await _setUseLocalAuth(false);
        return false;
      }
    } else {
      await _setUseLocalAuth(false);
    }
    return true;
  }
}
