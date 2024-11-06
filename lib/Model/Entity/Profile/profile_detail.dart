import 'package:flutter/material.dart';

class ProfileDetail {
  final String title;
  final IconData icon;
  final Function onTap;

  ProfileDetail({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
