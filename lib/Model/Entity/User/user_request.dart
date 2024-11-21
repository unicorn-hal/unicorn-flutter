import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';

class UserRequest {
  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final UserGenderEnum? gender;
  final DateTime? birthDate;
  final String? address;
  final String? postalCode;
  final String? phoneNumber;
  final String? iconImageUrl;
  final double? bodyHeight;
  final double? bodyWeight;
  final String? occupation;

  UserRequest({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.birthDate,
    this.address,
    this.postalCode,
    this.phoneNumber,
    this.iconImageUrl,
    this.bodyHeight,
    this.bodyWeight,
    this.occupation,
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      userId: json['userID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      gender: UserGenderType.fromString(json['gender']),
      birthDate: DateFormat('yyyy-MM-dd').parse(json['birthDate']),
      address: json['address'],
      postalCode: json['postalCode'],
      phoneNumber: json['phoneNumber'],
      iconImageUrl: json['iconImage'],
      bodyHeight: json['bodyHeight'],
      bodyWeight: json['bodyWeight'],
      occupation: json['occupation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': UserGenderType.toStringValue(gender!),
      'birthDate': DateFormat('yyyy-MM-dd').format(birthDate!),
      'address': address,
      'postalCode': postalCode,
      'phoneNumber': phoneNumber,
      'iconImageUrl': iconImageUrl,
      'bodyHeight': bodyHeight,
      'bodyWeight': bodyWeight,
      'occupation': occupation,
    };
  }
}
