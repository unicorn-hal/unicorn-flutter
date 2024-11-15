import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_request.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Api/FamilyEmail/family_email_api.dart';
import 'package:unicorn_flutter/Service/Package/NativeContacts/native_contacts_service.dart';
import 'package:unicorn_flutter/Service/Package/PermissionHandler/permission_handler_service.dart';

class FamilyEmailController extends ControllerCore {
  /// Serviceのインスタンス化
  FamilyEmailApi get _familyEmailApi => FamilyEmailApi();

  /// コンストラクタ
  FamilyEmailController({super.from});

  /// 変数の定義
  late bool _isSyncContact;
  late String _title;
  late List<FamilyEmail>? _familyEmailList;

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
    _familyEmailList = await _familyEmailApi.getFamilyEmailList();
    if (_familyEmailList == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      return null;
    }
    return _familyEmailList;
  }

  /// 連絡先を同期させる関数
  Future<List<FamilyEmailRequest>> getFamilyEmailRequest() async {
    // パーミッションの許可確認は最初に必須
    PermissionHandlerService permissionHandlerService =
        PermissionHandlerService();
    await permissionHandlerService
        .checkAndRequestPermission(Permission.contacts);

    // FamilyEmailRequestモデルとして取得できる
    NativeContactsService nativeContactsService = NativeContactsService();
    final List<FamilyEmailRequest> res =
        await nativeContactsService.getFamilyEmailRequests();
    print(res[0].email);
    print(res[0].phoneNumber);
    return res;
  }

  bool checkDuplicate(FamilyEmailRequest syncFamilyEmail) {
    _familyEmailList!.any((familyEmail) =>
        (familyEmail.email == syncFamilyEmail.email) &&
        (familyEmail.phoneNumber == syncFamilyEmail.phoneNumber) &&
        (familyEmail.firstName + familyEmail.lastName ==
            syncFamilyEmail.firstName + syncFamilyEmail.lastName));
    return true;
  }
}
