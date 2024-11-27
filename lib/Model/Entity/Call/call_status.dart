class CallStatus {
  final bool isDoctorEntered;
  final bool isFinishedCall;

  CallStatus({
    required this.isDoctorEntered,
    required this.isFinishedCall,
  });

  factory CallStatus.fromJson(Map<String, dynamic> json) {
    return CallStatus(
      isDoctorEntered: json['is_doctor_entered'],
      isFinishedCall: json['is_finished_call'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_doctor_entered': isDoctorEntered,
      'is_finished_call': isFinishedCall,
    };
  }
}
