import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class PermissionHandlerService {
  /// パーミッションのリクエスト
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    switch (status) {
      case PermissionStatus.denied:
        Log.echo('$permission denied');
        break;
      case PermissionStatus.granted:
        Log.echo('$permission granted');
        break;
      case PermissionStatus.restricted:
        Log.echo('$permission restricted');
        break;
      case PermissionStatus.limited:
        Log.echo('$permission limited');
        break;
      case PermissionStatus.permanentlyDenied:
        Log.echo('$permission permanentlyDenied');
        break;
      case PermissionStatus.provisional:
        Log.echo('$permission provisional');
    }
    return status.isGranted;
  }

  /// パーミッションが許可されているか確認
  Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// パーミッションが許可されていない場合、リクエストする
  Future<bool> checkAndRequestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      Log.echo('$permission is already granted');
      return true;
    }
    return requestPermission(permission);
  }
}
