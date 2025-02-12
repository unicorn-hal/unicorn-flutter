import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_put_request.dart';

class FamilyEmail {
  final String familyEmailId;
  final String email;
  final String firstName;
  final String lastName;
  final String? iconImageUrl;

  FamilyEmail({
    required this.familyEmailId,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.iconImageUrl,
  });

  factory FamilyEmail.fromJson(Map<String, dynamic> json) {
    return FamilyEmail(
      familyEmailId: json['familyEmailID'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      iconImageUrl: json['iconImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'familyEmailID': familyEmailId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'iconImageUrl': iconImageUrl,
    };
  }

  FamilyEmailPutRequest toRequest() {
    return FamilyEmailPutRequest.fromJson(toJson());
  }
}
