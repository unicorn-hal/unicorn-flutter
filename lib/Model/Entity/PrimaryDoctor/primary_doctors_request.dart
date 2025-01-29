class PrimaryDoctorsRequest {
  final String doctorId;

  PrimaryDoctorsRequest({
    required this.doctorId,
  });

  factory PrimaryDoctorsRequest.fromJson(Map<String, dynamic> json) {
    return PrimaryDoctorsRequest(
      doctorId: json['doctorID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorID': doctorId,
    };
  }
}
