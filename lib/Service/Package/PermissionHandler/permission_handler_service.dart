import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerService {
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  Future<bool> checkAndRequestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) {
      return true;
    }
    return requestPermission(permission);
  }
}
