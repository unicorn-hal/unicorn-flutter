class PrimaryDoctorsRequest {
  final List<String> doctorIds;

  PrimaryDoctorsRequest({
    required this.doctorIds,
  });

  factory PrimaryDoctorsRequest.fromJson(Map<String, dynamic> json) {
    return PrimaryDoctorsRequest(
      doctorIds: (json['doctorIds'] as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorIds': doctorIds,
    };
  }
}
