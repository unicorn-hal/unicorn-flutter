class HealthCheckup {
  final String healthCheckupId;
  final String date;
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
