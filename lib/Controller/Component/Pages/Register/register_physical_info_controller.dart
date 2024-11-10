import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/User/physical_info.dart';

class RegisterPhysicalInfoController extends ControllerCore {
  late DateTime birthDate;
  UserGenderEnum? gender;
  double? bodyHeight;
  double? bodyWeight;

  final TextEditingController firstNameTextController = TextEditingController();
  final TextEditingController lastNameTextController = TextEditingController();
  final TextEditingController bodyHeightTextController =
      TextEditingController();
  final TextEditingController bodyWeightTextController =
      TextEditingController();

  @override
  void initialize() {
    birthDate = DateTime.now();
  }

  PhysicalInfo? submit() {
    if (validateField() == false) {
      return null;
    }
    PhysicalInfo physicalInfo = PhysicalInfo(
      firstName: firstNameTextController.text,
      lastName: lastNameTextController.text,
      gender: gender!,
      birthDate: birthDate,
      bodyHeight: double.tryParse(bodyHeightTextController.text.trim())!,
      bodyWeight: double.tryParse(bodyWeightTextController.text.trim())!,
    );
    return physicalInfo;
  }

  bool validateField() {
    List<String> emptyMessageField = [];
    firstNameTextController.text.isEmpty
        ? emptyMessageField.add("お名前（姓）")
        : null;
    lastNameTextController.text.isEmpty
        ? emptyMessageField.add("お名前（名）")
        : null;
    gender == null ? emptyMessageField.add("性別") : null;
    bodyHeightTextController.text.isEmpty ? emptyMessageField.add("身長") : null;
    bodyWeightTextController.text.isEmpty ? emptyMessageField.add("体重") : null;

    if (emptyMessageField.isNotEmpty) {
      Fluttertoast.showToast(msg: "${emptyMessageField.join(',')}が入力されていません。");
      return false;
    }
    return true;
  }
}
