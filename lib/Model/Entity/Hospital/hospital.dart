class Hospital {
  final String hospitalId;
  final String hospitalName;
  final String? address;
  final String? postalCode;
  final String? phoneNumber;

  Hospital({
    required this.hospitalId,
    required this.hospitalName,
    this.address,
    this.postalCode,
    this.phoneNumber,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      hospitalId: json['hospitalID'],
      hospitalName: json['hospitalName'],
      address: json['address'],
      postalCode: json['postalCode'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hospitalID': hospitalId,
      'hospitalName': hospitalName,
      'address': address,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
    };
  }
}
