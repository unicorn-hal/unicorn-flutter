class HealthCheckupRequest {
  final String healthCheckupId;
  final String date;
  final double bodyTemperature;
  final String bloodPressure;
  final String medicalRecord;

  HealthCheckupRequest({
    required this.healthCheckupId,
    required this.date,
    required this.bodyTemperature,
    required this.bloodPressure,
    required this.medicalRecord,
  });

  factory HealthCheckupRequest.fromJson(Map<String, dynamic> json) {
    return HealthCheckupRequest(
      healthCheckupId: json['healthCheckupID'],
      date: json['date'],
      bodyTemperature: json['bodyTemperature'],
      bloodPressure: json['bloodPressure'],
      medicalRecord: json['medicalRecord'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'healthCheckupID': healthCheckupId,
      'date': date,
      'bodyTemperature': bodyTemperature,
      'bloodPressure': bloodPressure,
      'medicalRecord': medicalRecord,
    };
  }
}
