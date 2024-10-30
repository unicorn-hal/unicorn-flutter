import 'package:intl/intl.dart';

class CallRequest {
  final String doctorId;
  final String userId;
  final DateTime callStartTime;
  final DateTime callEndTime;

  CallRequest({
    required this.doctorId,
    required this.userId,
    required this.callStartTime,
    required this.callEndTime,
  });

  factory CallRequest.fromJson(Map<String, dynamic> json) {
    return CallRequest(
      doctorId: json['doctorID'],
      userId: json['userID'],
      callStartTime: DateTime.parse(json['callStartTime']),
      callEndTime: DateTime.parse(json['callEndTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorID': doctorId,
      'userID': userId,
      'callStartTime':
          DateFormat('yyyy-MM-ddThh:mm:ss+09:00').format(callStartTime),
      'callEndTime':
          DateFormat('yyyy-MM-ddThh:mm:ss+09:00').format(callEndTime),
    };
  }
}
