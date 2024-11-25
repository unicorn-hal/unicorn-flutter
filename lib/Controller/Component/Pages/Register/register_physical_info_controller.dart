import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/physical_info.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';

class RegisterPhysicalInfoController extends ControllerCore {
  RegisterPhysicalInfoController({
    required this.context,
    required super.from,
  });

  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController bodyHeightTextController = TextEditingController();
  TextEditingController bodyWeightTextController = TextEditingController();

  late DateTime birthDate;
  UserGenderEnum? gender;
  BuildContext context;
  UserData userData = UserData();

  @override
  void initialize() {
    birthDate = DateTime.now();
  }

  void setTextEditingController() {
    if (from == Routes.profile) {
      firstNameTextController =
          TextEditingController(text: userData.user!.firstName);
      lastNameTextController =
          TextEditingController(text: userData.user!.lastName);
      gender = userData.user!.gender;
      birthDate = userData.user!.birthDate;
      bodyHeightTextController =
          TextEditingController(text: userData.user!.bodyHeight.toString());
      bodyWeightTextController =
          TextEditingController(text: userData.user!.bodyWeight.toString());
    } else {
      return;
    }
  }

  Future<UserRequest?> submit(UserRequest userRequest) async {
    if (validateField() == false) {
      return null;
    }

    PhysicalInfo physicalInfo = PhysicalInfo(
      firstName: firstNameTextController.text,
      lastName: lastNameTextController.text,
      gender: gender!,
      birthDate: birthDate,
      bodyHeight: double.tryParse(bodyHeightTextController.text)!,
      bodyWeight: double.tryParse(bodyWeightTextController.text)!,
    );

    if (from == Routes.profile) {
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
      Future<int> responceCode =
          UserApi().putUser(userId: userData.user!.userId, body: userRequest);
      if (await responceCode == 200) {
        Fluttertoast.showToast(msg: Strings.PROFILE_EDIT_COMPLETED_TEXT);
        return ProfileRoute().push(context);
      }
      if (await responceCode == 400) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        return ProfileRoute().push(context);
      }
      if (await responceCode == 500) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        return ProfileRoute().push(context);
      }
    }

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
