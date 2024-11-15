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
  FamilyEmailController(
      {super.from, required List<FamilyEmail>? registeredEmailList})
      : _registeredEmailList = registeredEmailList;
  final List<FamilyEmail>? _registeredEmailList;

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
  List<FamilyEmail>? get familyEmailList => _familyEmailList;

  /// Routeによって変数の値を変更
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
    }
    return _familyEmailList;
  }

  /// 連絡先を同期させる関数
  Future<List<FamilyEmailRequest>?> getFamilyEmailRequest() async {
    // パーミッションの許可確認は最初に必須
    PermissionHandlerService permissionHandlerService =
        PermissionHandlerService();
    bool requestPermission = await permissionHandlerService
        .checkAndRequestPermission(Permission.contacts);
    if (requestPermission == false) {
      return null;
    }

    // FamilyEmailRequestモデルとして取得できる
    NativeContactsService nativeContactsService = NativeContactsService();
    List<FamilyEmailRequest> res =
        await nativeContactsService.getFamilyEmailRequests();
    List<FamilyEmailRequest> familyEmailRequestList =
        res.where((res) => !checkDuplicate(res)).toList();
    return familyEmailRequestList;
  }

  /// 登録されているアドレスと同じアドレスかをチェックする関数
  bool checkDuplicate(FamilyEmailRequest syncFamilyEmail) {
    return _registeredEmailList!.any((registeredEmail) =>
        (registeredEmail.email == syncFamilyEmail.email) &&
        (registeredEmail.phoneNumber == syncFamilyEmail.phoneNumber) &&
        (registeredEmail.firstName + registeredEmail.lastName ==
            syncFamilyEmail.firstName + syncFamilyEmail.lastName));
  }
}
