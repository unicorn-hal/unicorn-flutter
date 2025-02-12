import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_review/in_app_review.dart';

class SystemInfoService {
  DeviceInfoPlugin get _deviceInfo => DeviceInfoPlugin();
  Future<PackageInfo> get _packageInfo async =>
      await PackageInfo.fromPlatform();
  InAppReview get _inAppReview => InAppReview.instance;

  Future<String> get appVersion async {
    final PackageInfo packageInfo = await _packageInfo;
    return packageInfo.version;
  }

  Future<String> get appBuildNumber async {
    final PackageInfo packageInfo = await _packageInfo;
    return packageInfo.buildNumber;
  }

  Future<String> get appName async {
    final PackageInfo packageInfo = await _packageInfo;
    return packageInfo.appName;
  }

  Future<String> get deviceOSVersion async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      return 'Android ${androidInfo.version.release}';
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      return 'iOS ${iosInfo.systemVersion}';
    }
    return 'Unknown';
  }

  Future<String> get deviceName async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.device;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.name;
    }
    return 'Unknown';
  }

  Future<String> get deviceModel async {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      return androidInfo.model;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.utsname.machine;
    }
    return 'Unknown';
  }

  Future<void> openReview() async {
    if (await _inAppReview.isAvailable()) {
      _inAppReview.openStoreListing(
        appStoreId: '6737767733',
      );
    } else {
      Fluttertoast.showToast(msg: 'リリース後はレビューお願いします！');
    }
  }
}
