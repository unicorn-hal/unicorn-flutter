import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';

class UserRequest {
  final String userId;
  final String firstName;
  final String lastName;
  final UserGenderEnum gender;
  final String birthDate;
  final String address;
  final String postalCode;
  final String phoneNumber;
  final String iconImage;
  final int bodyHeight;
  final int bodyWeight;
  final String occupation;

  UserRequest({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.address,
    required this.postalCode,
    required this.phoneNumber,
    required this.iconImage,
    required this.bodyHeight,
    required this.bodyWeight,
    required this.occupation,
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: UserGenderType.fromString(json['gender']),
      birthDate: json['birthDate'],
      address: json['address'],
      postalCode: json['postalCode'],
      phoneNumber: json['phoneNumber'],
      iconImage: json['iconImage'],
      bodyHeight: json['bodyHeight'],
      bodyWeight: json['bodyWeight'],
      occupation: json['occupation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'gender': UserGenderType.toStringValue(gender),
      'birthDate': birthDate,
      'address': address,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
      'iconImage': iconImage,
      'bodyHeight': bodyHeight,
      'bodyWeight': bodyWeight,
      'occupation': occupation,
    };
  }
}
