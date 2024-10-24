class HealthCheckupRequest {
  final String date;
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
      date: json['date'],
      bodyTemperature: json['bodyTemperature'],
      bloodPressure: json['bloodPressure'],
      medicalRecord: json['medicalRecord'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'bodyTemperature': bodyTemperature,
      'bloodPressure': bloodPressure,
      'medicalRecord': medicalRecord,
    };
  }
}
