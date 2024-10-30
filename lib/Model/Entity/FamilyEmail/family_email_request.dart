class FamilyEmailRequest {
  final String email;
  final String firstName;
  final String lastName;
  final String? iconImageUrl;
  final String phoneNumber;

  FamilyEmailRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.iconImageUrl,
    required this.phoneNumber,
  });

  factory FamilyEmailRequest.fromJson(Map<String, dynamic> json) {
    return FamilyEmailRequest(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      iconImageUrl: json['iconImageUrl'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'iconImageUrl': iconImageUrl,
      'phoneNumber': phoneNumber,
    };
  }
}
