import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:unicorn_flutter/Model/Entity/location_address_info.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/PermissionHandler/permission_handler_service.dart';

class LocationService {
  PermissionHandlerService get permissionHandlerService =>
      PermissionHandlerService();
  final String _baseUrl = 'https://zipcloud.ibsnet.co.jp/api/search';

  /// Geolocatorから現在地情報を取得する基礎サービス
  Future<Position?> getCurrentPosition() async {
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

  /// Geolocatorから現在地情報を取得し、郵便番号を取得するサービス
  Future<String?> _getCurrentPostalCode() async {
    try {
      Position? position = await getCurrentPosition();
      if (position == null) {
        throw Exception('Location Permission Denied');
      }

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return placemarks[0].postalCode;
    } catch (e) {
      Log.echo('Error: $e');
      return null;
    }
  }

  /// 現在位置から住所を取得するサービス
  Future<LocationAddressInfo?> getAddressFromPosition() async {
    try {
      String? postalCode = await _getCurrentPostalCode();
      if (postalCode == null) {
        throw Exception('Postal Code Not Found');
      }

      return await getAddressFromPostalCode(postalCode);
    } catch (e) {
      Log.echo('Error: $e');
      return null;
    }
  }

  /// 郵便番号からApiを利用して住所を取得するサービス
  Future<LocationAddressInfo?> getAddressFromPostalCode(
      String postalCode) async {
    try {
      postalCode = postalCode.replaceAll('-', '');
      if (postalCode.length != 7) {
        throw Exception('Invalid Postal Code');
      }
      String url = '$_baseUrl?zipcode=$postalCode';

      http.Response response = await http.get(Uri.parse(url));
      final String responseUtf8 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseUtf8);

      if (jsonResponse['results'] == null) {
        throw Exception('Address Not Found');
      }

      Map<String, dynamic> address = jsonResponse['results'][0];
      LocationAddressInfo addressInfo = LocationAddressInfo(
        postalCode: postalCode,
        prefecture: address['address1'],
        city: address['address2'],
        town: address['address3'],
      );

      return addressInfo;
    } catch (e) {
      Log.echo('Error: $e');
      return null;
    }
  }

  /// 住所から緯度経度を取得するサービス
  Future<LatLng?> getPositionFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isEmpty) {
        throw Exception('Location Not Found');
      }

      Location location = locations[0];
      LatLng position = LatLng(location.latitude, location.longitude);

      return position;
    } catch (e) {
      Log.echo('Error: $e');
      return null;
    }
  }

  /// 緯度経度から住所を取得するサービス
  Future<String?> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark placemark = placemarks[0];
      String address = '${placemark.administrativeArea}'
          '${placemark.locality}'
          '${placemark.subLocality}'
          '${placemark.name}';

      return address;
    } catch (e) {
      Log.echo('Error: $e');
      return null;
    }
  }
}
