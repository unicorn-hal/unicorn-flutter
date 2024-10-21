class AddressInfo {
  final String postalCode;
  final String prefecture;
  final String city;
  final String town;

  AddressInfo({
    required this.postalCode,
    required this.prefecture,
    required this.city,
    required this.town,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    return AddressInfo(
      postalCode: json['postalCode'],
      prefecture: json['prefecture'],
      city: json['city'],
      town: json['town'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postalCode': postalCode,
      'prefecture': prefecture,
      'city': city,
      'town': town,
    };
  }
}
