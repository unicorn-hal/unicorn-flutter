import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';

class FamilyEmailRegisterController extends ControllerCore {
  /// Serviceのインスタンス化

  /// コンストラクタ
  FamilyEmailRegisterController();

  /// 変数の定義
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  /// initialize()
  @override
  void initialize() {
    print('Controller Init');
  }

  /// 各関数の実装
}
