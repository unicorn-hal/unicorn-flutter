import 'package:permission_handler/permission_handler.dart' as package;
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class PermissionHandlerService {
  /// パーミッションのリクエスト
  Future<bool> requestPermission(package.Permission permission) async {
    final status = await permission.request();
    switch (status) {
      case package.PermissionStatus.denied:
        Log.echo('$permission denied');
        break;
      case package.PermissionStatus.granted:
        Log.echo('$permission granted');
        break;
      case package.PermissionStatus.restricted:
        Log.echo('$permission restricted');
        break;
      case package.PermissionStatus.limited:
        Log.echo('$permission limited');
        break;
      case package.PermissionStatus.permanentlyDenied:
        Log.echo('$permission permanentlyDenied');
        break;
      case package.PermissionStatus.provisional:
        Log.echo('$permission provisional');
    }
    return status.isGranted;
  }

  /// パーミッションが許可されているか確認
  Future<bool> checkPermission(package.Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// パーミッションが許可されていない場合、リクエストする
  Future<bool> checkAndRequestPermission(package.Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      Log.echo('$permission is already granted');
      return true;
    }
    return requestPermission(permission);
  }

  /// ビデオ通話専用: カメラとマイクのパーミッションをリクエストする
  Future<bool> requestVideoCallPermissions() async {
    final List<package.Permission> permissions = [
      package.Permission.camera,
      package.Permission.microphone,
    ];
    for (final permission in permissions) {
      final package.PermissionStatus status = await permission.request();
      if (status.isGranted || status.isLimited || status.isPermanentlyDenied) {
        Log.echo('$permission granted');
      } else {
        Log.echo('$permission denied');
        return false;
      }
    }
    return true;
  }

  /// Nativeの設定画面を開く
  Future<void> openAppSettings() async {
    try {
      final bool isOpened = await package.openAppSettings();
      if (!isOpened) {
        throw Exception('openAppSettings failed');
      }
    } catch (e) {
      Log.echo('Error: $e', symbol: '❌');
    }
  }
}
