import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_request.dart';

class Call {
  final String callReservationId;
  final String doctorId;
  final String userId;
  final DateTime callStartTime;
  final DateTime callEndTime;

  Call({
    required this.callReservationId,
    required this.doctorId,
    required this.userId,
    required this.callStartTime,
    required this.callEndTime,
  });

  factory Call.fromJson(Map<String, dynamic> json) {
    return Call(
      callReservationId: json['callReservationID'],
      doctorId: json['doctorID'],
      userId: json['userID'],
      callStartTime: DateTime.parse(json['callStartTime']),
      callEndTime: DateTime.parse(json['callEndTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'callReservationID': callReservationId,
      'doctorID': doctorId,
      'userID': userId,
      'callStartTime': DateFormat('yyyy-MM-ddTHH:mm:ss').format(callStartTime),
      'callEndTime': DateFormat('yyyy-MM-ddTHH:mm:ss').format(callEndTime),
    };
  }

  CallRequest toRequest() {
    return CallRequest.fromJson(toJson());
  }
}
