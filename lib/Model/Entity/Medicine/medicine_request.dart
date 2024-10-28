class MedicineRequest {
  final String medicineName;
  final int count;

  MedicineRequest({
    required this.medicineName,
    required this.count,
  });

  factory MedicineRequest.fromJson(Map<String, dynamic> json) {
    return MedicineRequest(
      medicineName: json['medicineName'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineName': medicineName,
      'count': count,
    };
  }
}
