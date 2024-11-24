import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/physical_info.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';

class RegisterPhysicalInfoController extends ControllerCore {
  late DateTime birthDate;
  UserGenderEnum? gender;
  UserData userData = UserData();

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

  UserRequest? submit() {
    if (validateField() == false) {
      return null;
    }

    // todo: 編集処理でき次第、修正加えます。
    PhysicalInfo physicalInfo = PhysicalInfo(
      firstName: firstNameTextController.text,
      lastName: lastNameTextController.text,
      gender: gender!,
      birthDate: birthDate,
      bodyHeight: double.tryParse(bodyHeightTextController.text)!,
      bodyWeight: double.tryParse(bodyWeightTextController.text)!,
    );

    UserRequest? userRequest = UserRequest(
      firstName: physicalInfo.firstName,
      lastName: physicalInfo.lastName,
      gender: physicalInfo.gender,
      birthDate: physicalInfo.birthDate,
      bodyHeight: physicalInfo.bodyHeight,
      bodyWeight: physicalInfo.bodyWeight,
    );

    return userRequest;
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
