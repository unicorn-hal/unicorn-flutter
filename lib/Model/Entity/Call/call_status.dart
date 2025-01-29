class CallStatus {
  final bool isDoctorEntered;

  CallStatus({
    required this.isDoctorEntered,
  });

  factory CallStatus.fromJson(Map<String, dynamic> json) {
    return CallStatus(
      isDoctorEntered: json['is_doctor_entered'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_doctor_entered': isDoctorEntered,
    };
  }
}
