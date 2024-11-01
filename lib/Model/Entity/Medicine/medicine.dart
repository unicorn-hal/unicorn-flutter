class Medicine {
  final String medicineId;
  final String medicineName;
  final int count;
  final int quantity;

  Medicine({
    required this.medicineId,
    required this.medicineName,
    required this.count,
    required this.quantity,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      medicineId: json['medicineID'],
      medicineName: json['medicineName'],
      count: json['count'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicineID': medicineId,
      'medicineName': medicineName,
      'count': count,
      'quantity': quantity,
    };
  }
}
