import 'package:intl/intl.dart';

class HealthCheckup {
  final String healthCheckupId;
  final DateTime date;
  final double bodyTemperature;
  final String bloodPressure;
  final String medicalRecord;

  HealthCheckup({
    required this.healthCheckupId,
    required this.date,
    required this.bodyTemperature,
    required this.bloodPressure,
    required this.medicalRecord,
  });

  factory HealthCheckup.fromJson(Map<String, dynamic> json) {
    return HealthCheckup(
      healthCheckupId: json['healthCheckupID'],
      date: DateFormat('yyyy-MM-dd').parse(json['date']),
      bodyTemperature: json['bodyTemperature'],
      bloodPressure: json['bloodPressure'],
      medicalRecord: json['medicalRecord'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'healthCheckupID': healthCheckupId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'bodyTemperature': bodyTemperature,
      'bloodPressure': bloodPressure,
      'medicalRecord': medicalRecord,
    };
  }
}
