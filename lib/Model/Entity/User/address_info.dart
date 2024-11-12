import 'package:flutter/material.dart';

class PhysicalInfo {
  final int addressNumber;
  final List<DropdownMenuItem<int>> countryList;
  final String address;
  final String addressDetail;

  PhysicalInfo({
    required this.addressNumber,
    required this.countryList,
    required this.address,
    required this.addressDetail,
  });
}
