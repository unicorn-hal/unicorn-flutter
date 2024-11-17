import 'package:unicorn_flutter/Constants/Enum/stun_server_enum.dart';

class AppConfig {
  final bool available;
  final STUNServerEnum stunServerType;

  AppConfig({
    required this.available,
    required this.stunServerType,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      available: json['available'],
      stunServerType: STUNServerType.fromString(json['stunServerType']),
    );
  }
}
