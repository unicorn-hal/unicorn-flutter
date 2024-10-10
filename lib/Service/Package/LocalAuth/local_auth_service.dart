import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

// tips: 現状iOSのみ対応。顔認証と指紋認証が同時に使えることは想定されない。

enum LocalAuthStatus {
  face,
  fingerprint,
  passcode,
  faild,
}

class LocalAuthService {
  final LocalAuthentication auth = LocalAuthentication();

  /// デバイスがローカル認証に対応しているかどうかを確認
  Future<bool> _isDeviceSupported() async {
    try {
      final bool isSupported = await auth.isDeviceSupported();
      return isSupported;
    } catch (e) {
      Log.echo('Error: $e');
      return false;
    }
  }

  /// 生体認証が可能かどうかを確認
  Future<bool> _isCanAuthenticateWithBiometrics() async {
    try {
      final bool canAuthenticate = await auth.canCheckBiometrics;
      return canAuthenticate;
    } catch (e) {
      Log.echo('Error: $e');
      return false;
    }
  }

  /// 利用可能な生体認証の種類を取得
  Future<List<BiometricType>> _getAvailableBiometrics() async {
    try {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      Log.echo('Available biometrics: $availableBiometrics');
      return availableBiometrics;
    } catch (e) {
      Log.echo('Error: $e', symbol: '🚫');
      return <BiometricType>[];
    }
  }

  /// ローカル認証の状態を取得
  Future<LocalAuthStatus> getLocalAuthStatus() async {
    if (!await _isDeviceSupported()) {
      return LocalAuthStatus.faild;
    }
    if (!await _isCanAuthenticateWithBiometrics()) {
      return LocalAuthStatus.passcode;
    }

    final List<BiometricType> availableBiometrics =
        await _getAvailableBiometrics();
    if (availableBiometrics.contains(BiometricType.face)) {
      return LocalAuthStatus.face;
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return LocalAuthStatus.fingerprint;
    }
    return LocalAuthStatus.faild;
  }

  /// ローカル認証を実行
  Future<void> authenticate() async {
    if (await getLocalAuthStatus() == LocalAuthStatus.faild) {
      Log.toast('Device not supported');
      return;
    }

    try {
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: Strings.LOCAL_AUTH_REASON_TEXT,
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
          biometricOnly: false,
        ),
      );
      Log.toast('Did authenticate: $didAuthenticate');
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable') {
        Log.toast('Not available: ${e.message}', symbol: '❗️');
      } else {
        rethrow;
      }
    } catch (e) {
      Log.echo('Error: $e', symbol: '🚫');
    }
  }
}
