import 'package:flutter/foundation.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';
import 'package:unicorn_flutter/Service/Package/ImageUtils/image_utils_service.dart';

class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final UserGenderEnum gender;
  final String birthDate;
  final String address;
  final String postalCode;
  final String phoneNumber;
  final Uint8List iconImage;
  final double bodyHeight;
  final double bodyWeight;
  final String occupation;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      gender: UserGenderType.fromString(json['gender']),
      birthDate: json['birthDate'],
      address: json['address'],
      postalCode: json['postalCode'],
      phoneNumber: json['phoneNumber'],
      iconImage: ImageUtilsService().b64ToUint8List(json['iconImage']),
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
      'email': email,
      'gender': UserGenderType.toStringValue(gender),
      'birthDate': birthDate,
      'address': address,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
      'iconImage': ImageUtilsService().uint8ListTob64(iconImage),
      'bodyHeight': bodyHeight,
      'bodyWeight': bodyWeight,
      'occupation': occupation,
    };
  }
}
