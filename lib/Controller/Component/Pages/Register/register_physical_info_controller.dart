import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/physical_info.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class RegisterPhysicalInfoController extends ControllerCore {
  UserApi get _userApi => UserApi();

  RegisterPhysicalInfoController({
    required this.context,
    required super.from,
  });

  BuildContext context;

  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController bodyHeightTextController = TextEditingController();
  TextEditingController bodyWeightTextController = TextEditingController();

  late DateTime birthDate;
  UserGenderEnum? gender;
  UserData userData = UserData();

  @override
  void initialize() {
    birthDate = DateTime.now();
  }

  void setTextEditingController() {
    if (from == Routes.profile) {
      firstNameTextController.text = userData.user!.firstName;
      lastNameTextController.text = userData.user!.lastName;
      gender = userData.user!.gender;
      birthDate = userData.user!.birthDate;
      bodyHeightTextController.text = userData.user!.bodyHeight.toString();
      bodyWeightTextController.text = userData.user!.bodyWeight.toString();
    } else {
      return;
    }
  }

  Future<void> submit(UserRequest userRequest) async {
    if (validateField() == false) {
      return;
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
      userRequest = UserRequest(
        userId: userData.user!.userId,
        email: userData.user!.email,
        address: userData.user!.address,
        postalCode: userData.user!.postalCode,
        phoneNumber: userData.user!.phoneNumber,
        iconImageUrl: userData.user!.iconImageUrl,
        occupation: userData.user!.occupation,
        firstName: physicalInfo.firstName,
        lastName: physicalInfo.lastName,
        gender: physicalInfo.gender,
        birthDate: physicalInfo.birthDate,
        bodyHeight: physicalInfo.bodyHeight,
        bodyWeight: physicalInfo.bodyWeight,
      );
      ProtectorNotifier().enableProtector();
      Future<int> responceCode =
          _userApi.putUser(userId: userData.user!.userId, body: userRequest);
      ProtectorNotifier().disableProtector();
      if (await responceCode == 200) {
        // シングルトンに登録した値をセットする
        userData.setUser(User.fromJson(userRequest.toJson()));
        Fluttertoast.showToast(msg: Strings.PROFILE_EDIT_COMPLETED_MESSAGE);
        ProfileRoute().push(context);
        return;
      }
      if (await responceCode == 400) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        ProfileRoute().push(context);
        return;
      }
      if (await responceCode == 500) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        ProfileRoute().push(context);
        return;
      }
    }

    userRequest = UserRequest(
      firstName: physicalInfo.firstName,
      lastName: physicalInfo.lastName,
      gender: physicalInfo.gender,
      birthDate: physicalInfo.birthDate,
      bodyHeight: physicalInfo.bodyHeight,
      bodyWeight: physicalInfo.bodyWeight,
    );

    RegisterAddressInfoRoute(
            from: Routes.registerPhysicalInfo, $extra: userRequest)
        .push(context);
    return;
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
