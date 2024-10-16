import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn_flutter/Model/Entiry/location.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/PermissionHandler/permission_handler_service.dart';

class GeolocatorService {
  PermissionHandlerService get permissionHandlerService =>
      PermissionHandlerService();

  /// Geolocatorから現在地情報を取得する基礎サービス
  Future<Position?> _getPosition() async {
    try {
      bool permission = await permissionHandlerService
          .checkAndRequestPermission(Permission.location);
      if (!permission) {
        throw Exception('Location Permission Denied');
      }

      Position position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      Log.echo('Error: $e');
      return null;
    }
  }

  /// 現在地情報をカスタムクラスで返却する
  Future<Location?> getLocation() async {
    Position position = await _getPosition();
    if (position == null) {
      return null;
    }
    return Location.fromJson({
      'lat': position.latitude,
      'lng': position.longitude,
    });
  }
}
