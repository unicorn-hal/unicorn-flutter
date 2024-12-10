import 'package:unicorn_flutter/Constants/Enum/unicorn_status_enum.dart';

class UnicornSupport {
  final UnicornStatusEnum status;
  final String robotId;
  final String robotName;
  final double? robotLatitude;
  final double? robotLongitude;

  UnicornSupport({
    required this.status,
    required this.robotId,
    required this.robotName,
    this.robotLatitude,
    this.robotLongitude,
  });

  factory UnicornSupport.fromJson(Map<String, dynamic> json) {
    return UnicornSupport(
      status: UnicornStatusType.fromString(json['status']),
      robotId: json['robotID'],
      robotName: json['robotName'],
      robotLatitude: json['robotLatitude'],
      robotLongitude: json['robotLongitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': UnicornStatusType.toStringValue(status),
      'robotID': robotId,
      'robotName': robotName,
      'robotLatitude': robotLatitude,
      'robotLongitude': robotLongitude,
    };
  }
}
