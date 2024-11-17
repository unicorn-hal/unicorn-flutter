import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Service/Api/FamilyEmail/family_email_api.dart';

class FamilyEmailController extends ControllerCore {
  /// Serviceのインスタンス化
  FamilyEmailApi get _familyEmailApi => FamilyEmailApi();

  /// 変数の定義
  List<FamilyEmail>? _familyEmailList;

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装
  List<FamilyEmail>? get familyEmailList => _familyEmailList;

  /// FamilyEmailListを取得する関数
  Future<List<FamilyEmail>?> getFamilyEmail() async {
    _familyEmailList = await _familyEmailApi.getFamilyEmailList();
    if (_familyEmailList == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    return _familyEmailList;
  }
}
