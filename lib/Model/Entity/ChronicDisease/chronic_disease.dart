class ChronicDisease {
  final String chronicDiseaseId;
  final String diseaseName;

  ChronicDisease({
    required this.chronicDiseaseId,
    required this.diseaseName,
  });

  factory ChronicDisease.fromJson(Map<String, dynamic> json) {
    return ChronicDisease(
      chronicDiseaseId: json['chronicDiseaseID'],
      diseaseName: json['diseaseName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chronicDiseaseID': chronicDiseaseId,
      'diseaseName': diseaseName,
    };
  }
}
