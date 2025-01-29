import 'package:flutter/material.dart';

class ProfileDetail {
  final String title;
  final Image iconImage;
  final Function onTap;

  ProfileDetail({
    required this.title,
    required this.iconImage,
    required this.onTap,
  });
}
