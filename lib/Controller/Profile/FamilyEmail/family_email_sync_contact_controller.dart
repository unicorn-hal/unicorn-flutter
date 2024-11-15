import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_request.dart';
import 'package:unicorn_flutter/Service/Api/FamilyEmail/family_email_api.dart';
import 'package:unicorn_flutter/Service/Package/NativeContacts/native_contacts_service.dart';
import 'package:unicorn_flutter/Service/Package/PermissionHandler/permission_handler_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class FamilyEmailSyncContactController extends ControllerCore {
  /// Serviceのインスタンス化
  FamilyEmailApi get _familyEmailApi => FamilyEmailApi();

  /// コンストラクタ
  FamilyEmailSyncContactController(this._familyEmailList);
  List<FamilyEmail>? _familyEmailList;

  /// 変数の定義

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装

  /// 連絡先を同期させる関数
  Future<List<FamilyEmailRequest>?> getFamilyEmailRequest() async {
    // パーミッションの許可確認は最初に必須
    PermissionHandlerService permissionHandlerService =
        PermissionHandlerService();
    bool requestPermission = await permissionHandlerService
        .checkAndRequestPermission(Permission.contacts);
    if (requestPermission == false) {
      Fluttertoast.showToast(msg: Strings.REQUEST_PERMISSION_ERROR_TEXT);
      return null;
    }
    // FamilyEmailRequestモデルとして取得できる
    NativeContactsService nativeContactsService = NativeContactsService();
    List<FamilyEmailRequest> res =
        await nativeContactsService.getFamilyEmailRequests();
    if (_familyEmailList == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      return null;
    }
    List<FamilyEmailRequest> familyEmailRequestList =
        res.where((res) => !checkDuplicate(res)).toList();
    return familyEmailRequestList;
  }

  /// 登録されているアドレスと同じアドレスかをチェックする関数
  bool checkDuplicate(FamilyEmailRequest syncFamilyEmail) {
    return _familyEmailList!.any((registeredEmail) =>
        (registeredEmail.email == syncFamilyEmail.email) &&
        (registeredEmail.phoneNumber == syncFamilyEmail.phoneNumber) &&
        (registeredEmail.firstName + registeredEmail.lastName ==
            syncFamilyEmail.firstName + syncFamilyEmail.lastName));
  }

  /// 同期したメールアドレスを登録する関数
  Future<int> postFamilyEmail(FamilyEmailRequest email) async {
    ProtectorNotifier().enableProtector();
    int res = await _familyEmailApi.postFamilyEmail(body: email);
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    ProtectorNotifier().disableProtector();
    return res;
  }

  /// FamilyEmailListを更新する関数
  Future<void> updateFamilyEmail() async {
    ProtectorNotifier().enableProtector();
    _familyEmailList = await _familyEmailApi.getFamilyEmailList();
    if (_familyEmailList == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    ProtectorNotifier().disableProtector();
  }
}
