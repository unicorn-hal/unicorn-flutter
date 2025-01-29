import 'dart:typed_data';

class FamilyEmailPostRequest {
  final String familyEmailId;
  final String email;
  final String firstName;
  final String lastName;
  String? iconImageUrl;
  Uint8List? avatar;

  FamilyEmailPostRequest({
    required this.familyEmailId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.iconImageUrl,
    this.avatar,
  });

  factory FamilyEmailPostRequest.fromJson(Map<String, dynamic> json) {
    final request = FamilyEmailPostRequest(
      familyEmailId: json['familyEmailID'],
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
      'familyEmailID': familyEmailId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'iconImageUrl': iconImageUrl,
      'avatar': avatar,
    };
  }
}
