import 'package:unicorn_flutter/Model/Entity/Department/department.dart';
import 'package:unicorn_flutter/Model/Entity/Hospital/hospital.dart';

class Doctor {
  final String doctorId;
  final Hospital hospital;
  final String firstName;
  final String lastName;
  final String? doctorIconUrl;
  final List<Department> departments;
  final String email;
  final String phoneNumber;
  final String chatSupportHours;
  final String callSupportHours;

  Doctor({
    required this.doctorId,
    required this.hospital,
    required this.firstName,
    required this.lastName,
    required this.doctorIconUrl,
    required this.departments,
    required this.email,
    required this.phoneNumber,
    required this.chatSupportHours,
    required this.callSupportHours,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctorID'],
      hospital: Hospital.fromJson(json['hospital']),
      firstName: json['firstName'],
      lastName: json['lastName'],
      doctorIconUrl: json['doctorIconUrl'],
      departments: (json['departments'] as List)
          .map((e) => Department.fromJson(e))
          .toList(),
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      chatSupportHours: json['chatSupportHours'],
      callSupportHours: json['callSupportHours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorID': doctorId,
      'hospital': hospital.toJson(),
      'firstName': firstName,
      'lastName': lastName,
      'doctorIconUrl': doctorIconUrl,
      'departments': departments.map((e) => e.toJson()).toList(),
      'email': email,
      'phoneNumber': phoneNumber,
      'chatSupportHours': chatSupportHours,
      'callSupportHours': callSupportHours,
    };
  }
}
