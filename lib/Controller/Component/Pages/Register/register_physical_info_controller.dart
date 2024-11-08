import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';

class RegisterPhysicalInfoController extends ControllerCore {
  UserApi get _userApi => UserApi();
  late String firstName;
  late String lastName;
  UserGenderEnum? gender;
  late DateTime birthDate;
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
    firstName = firstNameTextController.text;
    lastName = lastNameTextController.text;
    birthDate = DateTime.now();
    bodyHeight = double.tryParse(bodyHeightTextController.text);
    bodyWeight = double.tryParse(bodyWeightTextController.text);
  }
}
