import 'dart:typed_data';

class FamilyEmailRequest {
  final String email;
  final String firstName;
  final String lastName;
  String? iconImageUrl;
  Uint8List? avatar;

  FamilyEmailRequest({
    required this.email,
    required this.firstName,
    required this.lastName,
    this.iconImageUrl,
    this.avatar,
  });

  factory FamilyEmailRequest.fromJson(Map<String, dynamic> json) {
    final request = FamilyEmailRequest(
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
    if (json['avatar'] != null) {
      request.avatar = json['avatar'];
    } else {
      request.iconImageUrl = json['iconImageUrl'];
    }
    return request;
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'iconImageUrl': iconImageUrl,
      'avatar': avatar,
    };
  }
}
