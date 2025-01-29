class Disease {
  final int diseaseId;
  final String diseaseName;

  Disease({
    required this.diseaseId,
    required this.diseaseName,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      diseaseId: json['diseaseID'],
      diseaseName: json['diseaseName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'diseaseID': diseaseId,
      'diseaseName': diseaseName,
    };
  }
}
