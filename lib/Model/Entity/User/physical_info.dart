import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';

class PhysicalInfo {
  final String firstName;
  final String lastName;
  final UserGenderEnum? gender;
  final DateTime birthDate;
  final double? bodyHeight;
  final double? bodyWeight;

  PhysicalInfo({
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.birthDate,
    required this.bodyHeight,
    required this.bodyWeight,
  });
}
