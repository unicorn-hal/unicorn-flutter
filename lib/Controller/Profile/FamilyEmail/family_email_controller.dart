import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Api/FamilyEmail/family_email_api.dart';

class FamilyEmailController extends ControllerCore {
  /// Serviceのインスタンス化
  FamilyEmailApi get _familyEmailApi => FamilyEmailApi();

  /// コンストラクタ
  FamilyEmailController({super.from});

  /// 変数の定義
  late bool _isSyncContact;
  late String _title;

  /// initialize()
  @override
  void initialize() {
    checkRoute();
  }

  /// 各関数の実装
  bool get isSyncContact => _isSyncContact;
  String get title => _title;

  ///
  void checkRoute() {
    if (from == Routes.profile) {
      _isSyncContact = false;
      _title = '登録済み';
      return;
    }
    _isSyncContact = true;
    _title = '未登録';
  }

  /// FamilyEmailListを取得する関数
  Future<List<FamilyEmail>?> getFamilyEmail() async {
    List<FamilyEmail>? familyEmailList =
        await _familyEmailApi.getFamilyEmailList();
    if (familyEmailList == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      return null;
    }
    return familyEmailList;
  }
}
