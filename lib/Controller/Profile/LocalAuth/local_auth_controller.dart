import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Service/Package/LocalAuth/local_auth_service.dart';
import 'package:unicorn_flutter/Service/Package/SharedPreferences/shared_preferences_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';

class LocalAuthController {
  final SharedPreferencesService _sharedPreferencesService =
      SharedPreferencesService();
  final LocalAuthService _localAuthService = LocalAuthService();

  Future<bool> getUseLocalAuth() async {
    return await _sharedPreferencesService.getBool('useLocalAuth') ?? false;
  }

  Future<void> setUseLocalAuth(bool value) async {
    await _sharedPreferencesService.setBool('useLocalAuth', value);
  }

  Future<void> loadUseLocalAuth(Function(bool) callback) async {
    bool useLocalAuth = await getUseLocalAuth();
    callback(useLocalAuth);
  }

  Future<void> updateUseLocalAuth(bool value, Function(bool) callback) async {
    await setUseLocalAuth(value);
    callback(value);
  }

  Future<bool> checkLocalAuth(BuildContext context, bool useLocalAuth) async {
    if (useLocalAuth) {
      bool isAuthenticated = false;
      try {
        await _localAuthService.authenticate();
        isAuthenticated = true;
      } catch (error) {
        Log.toast('Local Authentication failed');
        _showAuthFailedDialog(context, useLocalAuth);
      }

      if (!isAuthenticated) {
        return false;
      }
    }
    return true;
  }

  void _showAuthFailedDialog(BuildContext context, bool useLocalAuth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          title: '認証に失敗しました',
          bodyText: '再度認証を行ってください',
          rightButtonText: 'もう一度行う',
          customButtonCount: 2,
          rightButtonOnTap: () {
            Navigator.of(context).pop();
            checkLocalAuth(context, useLocalAuth);
          },
        );
      },
    );
  }
}
