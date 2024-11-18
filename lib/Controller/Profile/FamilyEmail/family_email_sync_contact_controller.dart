import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_post_request.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_request.dart';
import 'package:unicorn_flutter/Service/Api/FamilyEmail/family_email_api.dart';
import 'package:unicorn_flutter/Service/Package/NativeContacts/native_contacts_service.dart';
import 'package:unicorn_flutter/Service/Package/PermissionHandler/permission_handler_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:uuid/uuid.dart';

class FamilyEmailSyncContactController extends ControllerCore {
  /// Serviceのインスタンス化
  FamilyEmailApi get _familyEmailApi => FamilyEmailApi();
  PermissionHandlerService get _permissionHandlerService =>
      PermissionHandlerService();
  NativeContactsService get _nativeContactsService => NativeContactsService();

  /// コンストラクタ
  FamilyEmailSyncContactController(this._familyEmailList);
  List<FamilyEmail>? _familyEmailList;

  /// initialize()
  @override
  void initialize() {}

  /// 連絡先を同期させる関数
  Future<List<FamilyEmailPutRequest>?> getFamilyEmailRequest() async {
    if (_familyEmailList == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      return null;
    }
    // パーミッションの許可確認は最初に必須
    bool requestPermission = await _permissionHandlerService
        .checkAndRequestPermission(Permission.contacts);
    if (requestPermission == false) {
      Fluttertoast.showToast(msg: Strings.REQUEST_PERMISSION_ERROR_TEXT);
      return null;
    }
    // FamilyEmailRequestモデルとして取得できる
    List<FamilyEmailPutRequest> res =
        await _nativeContactsService.getFamilyEmailRequests();
    List<FamilyEmailPutRequest> familyEmailRequestList =
        res.where((res) => !checkDuplicate(res)).toList();
    return familyEmailRequestList;
  }

  /// 登録されているアドレスと同じアドレスかをチェックする関数
  bool checkDuplicate(FamilyEmailPutRequest syncFamilyEmail) {
    return _familyEmailList!.any((registeredEmail) =>
        (registeredEmail.email == syncFamilyEmail.email) &&
        (registeredEmail.firstName + registeredEmail.lastName ==
            syncFamilyEmail.firstName + syncFamilyEmail.lastName));
  }

  /// 同期したメールアドレスを登録する関数
  Future<int> postFamilyEmail(FamilyEmailPutRequest syncFamilyEmail) async {
    ProtectorNotifier().enableProtector();
    if (syncFamilyEmail.email == '' ||
        (syncFamilyEmail.firstName == '' || syncFamilyEmail.lastName == '')) {
      Fluttertoast.showToast(msg: Strings.FAMILY_EMAIL_VALIDATE_TEXT);
      ProtectorNotifier().disableProtector();
      return 400;
    }
    String familyEmailId = const Uuid().v4();
    FamilyEmailPostRequest body = FamilyEmailPostRequest(
      familyEmailId: familyEmailId,
      email: syncFamilyEmail.email,
      firstName: syncFamilyEmail.firstName,
      lastName: syncFamilyEmail.lastName,
      iconImageUrl: syncFamilyEmail.iconImageUrl,
    );
    int res = await _familyEmailApi.postFamilyEmail(
      body: body,
    );
    if (res == 200) {
      Fluttertoast.showToast(
          msg:
              '${syncFamilyEmail.lastName} ${syncFamilyEmail.firstName}さんを家族メールに設定しました');
    } else {
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
