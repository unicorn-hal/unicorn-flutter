import 'package:flutter/material.dart';

class UserInfo {
  final Image image;
  final String phoneNumber;
  final String email;
  final String occupation;

  UserInfo(
      {required this.image,
      required this.phoneNumber,
      required this.email,
      required this.occupation});
}
