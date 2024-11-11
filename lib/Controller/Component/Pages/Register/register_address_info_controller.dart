import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/prefectures.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';

class RegisterAddressInfoController extends ControllerCore {
  final TextEditingController addressNumber = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController addressDetail = TextEditingController();
  final List<String> entryItemStrings = ['未設定'] + Prefectures.list;

  @override
  void initialize() {}
}
