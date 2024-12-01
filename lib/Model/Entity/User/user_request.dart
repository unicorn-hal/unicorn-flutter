import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';

class UserRequest {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  UserGenderEnum? gender;
  DateTime? birthDate;
  String? address;
  String? postalCode;
  String? phoneNumber;
  String? iconImageUrl;
  double? bodyHeight;
  double? bodyWeight;
  String? occupation;

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
      iconImageUrl: json['iconImageUrl'],
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
