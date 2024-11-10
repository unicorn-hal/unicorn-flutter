class ChronicDiseaseRequest {
  final int diseaseId;

  ChronicDiseaseRequest({
    required this.diseaseId,
  });

  factory ChronicDiseaseRequest.fromJson(Map<String, dynamic> json) {
    return ChronicDiseaseRequest(
      diseaseId: json['diseaseID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseaseID': diseaseId,
    };
  }
}
