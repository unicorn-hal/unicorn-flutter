import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/physical_info.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';

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

  Future<void> setValuesFromGetUser(UserData userData) async {
    await UserApi().getUser(userId: userData.user!.userId);

    PhysicalInfo physicalInfo = PhysicalInfo(
      firstName: firstNameTextController.text,
      lastName: lastNameTextController.text,
      gender: gender!,
      birthDate: birthDate,
      bodyHeight: double.tryParse(bodyHeightTextController.text)!,
      bodyWeight: double.tryParse(bodyWeightTextController.text)!,
    );

    UserRequest userRequest = UserRequest(
      userId: userData.user!.userId,
      firstName: physicalInfo.firstName,
      lastName: physicalInfo.lastName,
      email: userData.user!.email,
      gender: physicalInfo.gender,
      birthDate: physicalInfo.birthDate,
      address: userData.user!.address,
      postalCode: userData.user!.postalCode,
      phoneNumber: userData.user!.phoneNumber,
      iconImageUrl: userData.user!.iconImageUrl,
      bodyHeight: physicalInfo.bodyHeight,
      bodyWeight: physicalInfo.bodyWeight,
      occupation: userData.user!.occupation,
    );

    UserApi().putUser(userId: userData.user!.userId, body: userRequest);
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
