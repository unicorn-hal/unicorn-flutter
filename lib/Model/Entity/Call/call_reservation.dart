import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';

class CallReservation {
  final String callReservationId;
  final String userId;
  final DateTime callStartTime;
  final DateTime callEndTime;
  final Doctor doctor;

  CallReservation({
    required this.callReservationId,
    required this.userId,
    required this.callStartTime,
    required this.callEndTime,
    required this.doctor,
  });

  factory CallReservation.fromJson(Map<String, dynamic> json) {
    return CallReservation(
      callReservationId: json['callReservationID'],
      userId: json['userID'],
      callStartTime: DateTime.parse(json['callStartTime']),
      callEndTime: DateTime.parse(json['callEndTime']),
      doctor: Doctor.fromJson(json['doctor']),
    );
  }
}
