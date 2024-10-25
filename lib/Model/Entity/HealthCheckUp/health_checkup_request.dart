import 'package:intl/intl.dart';

class HealthCheckupRequest {
  final DateTime date;
  final double bodyTemperature;
  final String bloodPressure;
  final String medicalRecord;

  HealthCheckupRequest({
    required this.date,
    required this.bodyTemperature,
    required this.bloodPressure,
    required this.medicalRecord,
  });

  factory HealthCheckupRequest.fromJson(Map<String, dynamic> json) {
    return HealthCheckupRequest(
      date: DateTime.parse(json['date']),
      bodyTemperature: json['bodyTemperature'],
      bloodPressure: json['bloodPressure'],
      medicalRecord: json['medicalRecord'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date),
      'bodyTemperature': bodyTemperature,
      'bloodPressure': bloodPressure,
      'medicalRecord': medicalRecord,
    };
  }
}
