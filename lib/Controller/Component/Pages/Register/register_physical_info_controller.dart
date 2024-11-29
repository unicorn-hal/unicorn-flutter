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
  /// Serviceのインスタンス化
  UserApi get _userApi => UserApi();

  /// コンストラクタ
  RegisterPhysicalInfoController({
    required this.context,
    required super.from,
  });
  BuildContext context;

  /// 変数の定義
  TextEditingController firstNameTextController = TextEditingController();
  TextEditingController lastNameTextController = TextEditingController();
  TextEditingController bodyHeightTextController = TextEditingController();
  TextEditingController bodyWeightTextController = TextEditingController();

  bool _useAppbar = false;
  late DateTime birthDate;
  UserGenderEnum? gender;
  UserData userData = UserData();

  /// initialize()
  @override
  void initialize() {
    birthDate = DateTime.now();
    _setDefaultValue();
  }

  /// 各関数の実装
  bool get useAppbar => _useAppbar;

  void _setDefaultValue() {
    if (from == Routes.profile) {
      _useAppbar = true;
      firstNameTextController.text = userData.user!.firstName;
      lastNameTextController.text = userData.user!.lastName;
      gender = userData.user!.gender;
      birthDate = userData.user!.birthDate;
      bodyHeightTextController.text = userData.user!.bodyHeight.toString();
      bodyWeightTextController.text = userData.user!.bodyWeight.toString();
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

    userRequest.firstName = physicalInfo.firstName;
    userRequest.lastName = physicalInfo.lastName;
    userRequest.gender = physicalInfo.gender;
    userRequest.birthDate = physicalInfo.birthDate;
    userRequest.bodyHeight = physicalInfo.bodyHeight;
    userRequest.bodyWeight = physicalInfo.bodyWeight;

    if (from == Routes.profile) {
      ProtectorNotifier().enableProtector();
      int statusCode = await _userApi.putUser(
          userId: userData.user!.userId, body: userRequest);
      ProtectorNotifier().disableProtector();
      if (statusCode != 200) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      } else {
        // シングルトンに登録した値をセットする
        userData.setUser(User.fromJson(userRequest.toJson()));
        Fluttertoast.showToast(msg: Strings.PROFILE_EDIT_COMPLETED_MESSAGE);
      }
      // ignore: use_build_context_synchronously
      const ProfileRoute().go(context);
      return;
    }

    RegisterAddressInfoRoute($extra: userRequest).push(context);
    return;
  }

  bool validateField() {
    List<String> emptyMessageField = [];
    firstNameTextController.text.isEmpty
        ? emptyMessageField.add("お名前（名）")
        : null;
    lastNameTextController.text.isEmpty
        ? emptyMessageField.add("お名前（姓）")
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
