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
  late DateTime _birthDate;
  UserGenderEnum? _gender;
  final UserData _userData = UserData();

  /// initialize()
  @override
  void initialize() {
    _birthDate = DateTime.now().subtract(const Duration(days: 1));
    _setDefaultValue();
  }

  /// 各関数の実装
  bool get useAppbar => _useAppbar;
  DateTime get birthDate => _birthDate;
  UserGenderEnum? get gender => _gender;
  void setBirthDate(DateTime birthDate) {
    _birthDate = birthDate;
  }

  void setGender(UserGenderEnum gender) {
    _gender = gender;
  }

  void _setDefaultValue() {
    if (from == Routes.profile) {
      _useAppbar = true;
      firstNameTextController.text = _userData.user!.firstName;
      lastNameTextController.text = _userData.user!.lastName;
      _gender = _userData.user!.gender;
      _birthDate = _userData.user!.birthDate;
      bodyHeightTextController.text = _userData.user!.bodyHeight.toString();
      bodyWeightTextController.text = _userData.user!.bodyWeight.toString();
    }
  }

  Future<void> submit(UserRequest userRequest) async {
    if (validateField() == false) {
      return;
    }

    PhysicalInfo physicalInfo = PhysicalInfo(
      firstName: firstNameTextController.text,
      lastName: lastNameTextController.text,
      gender: _gender!,
      birthDate: _birthDate,
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
      if (_userData.user!.lastName == lastNameTextController.text &&
          _userData.user!.firstName == firstNameTextController.text &&
          _userData.user!.gender == _gender &&
          _userData.user!.birthDate == _birthDate &&
          _userData.user!.bodyHeight.toString() ==
              bodyHeightTextController.text &&
          _userData.user!.bodyWeight.toString() ==
              bodyWeightTextController.text) {
        const ProfileRoute().go(context);
        return;
      }
      ProtectorNotifier().enableProtector();
      int statusCode = await _userApi.putUser(
          userId: _userData.user!.userId, body: userRequest);
      ProtectorNotifier().disableProtector();
      if (statusCode != 200) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      } else {
        // シングルトンに登録した値をセットする
        _userData.setUser(User.fromJson(userRequest.toJson()));
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
    _gender == null ? emptyMessageField.add("性別") : null;
    bodyHeightTextController.text.isEmpty ? emptyMessageField.add("身長") : null;
    bodyWeightTextController.text.isEmpty ? emptyMessageField.add("体重") : null;

    if (emptyMessageField.isNotEmpty) {
      Fluttertoast.showToast(msg: "${emptyMessageField.join(',')}が入力されていません。");
      return false;
    }
    return true;
  }
}
