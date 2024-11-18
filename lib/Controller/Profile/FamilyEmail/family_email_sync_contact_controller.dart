import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn_flutter/Constants/regexp_constants.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_post_request.dart';
import 'package:unicorn_flutter/Service/Api/FamilyEmail/family_email_api.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudStorage/cloud_storage_service.dart';
import 'package:unicorn_flutter/Service/Package/ImageUtils/image_utils_service.dart';
import 'package:unicorn_flutter/Service/Package/NativeContacts/native_contacts_service.dart';
import 'package:unicorn_flutter/Service/Package/PermissionHandler/permission_handler_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class FamilyEmailSyncContactController extends ControllerCore {
  /// Serviceのインスタンス化
  FamilyEmailApi get _familyEmailApi => FamilyEmailApi();
  PermissionHandlerService get _permissionHandlerService =>
      PermissionHandlerService();
  NativeContactsService get _nativeContactsService => NativeContactsService();
  ImageUtilsService get _imageUtilsService => ImageUtilsService();
  FirebaseCloudStorageService get _cloudStorageService =>
      FirebaseCloudStorageService();

  /// コンストラクタ
  FamilyEmailSyncContactController(this._familyEmailList);
  List<FamilyEmail>? _familyEmailList;

  /// initialize()
  @override
  void initialize() {}

  Image uint8ListToImage(Uint8List? avatar) {
    return _imageUtilsService.uint8ListToImage(avatar!);
  }

  /// 連絡先を同期させる関数
  Future<List<FamilyEmailPostRequest>?> getFamilyEmailRequest() async {
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
    // FamilyEmailPutRequestモデルとして取得できる
    List<FamilyEmailPostRequest> res =
        await _nativeContactsService.getFamilyEmailRequests();
    List<FamilyEmailPostRequest> familyEmailRequestList =
        res.where((res) => !checkDuplicate(res)).toList();
    return familyEmailRequestList;
  }

  /// 登録されているアドレスと同じアドレスかをチェックする関数
  bool checkDuplicate(FamilyEmailPostRequest syncFamilyEmail) {
    return _familyEmailList!.any((registeredEmail) =>
        (registeredEmail.email == syncFamilyEmail.email) &&
        (registeredEmail.firstName + registeredEmail.lastName ==
            syncFamilyEmail.firstName + syncFamilyEmail.lastName));
  }

  /// 同期したメールアドレスを登録する関数
  Future<int> postFamilyEmail(FamilyEmailPostRequest syncFamilyEmail) async {
    if (syncFamilyEmail.email == '' ||
        (syncFamilyEmail.firstName == '' || syncFamilyEmail.lastName == '')) {
      Fluttertoast.showToast(msg: Strings.FAMILY_EMAIL_VALIDATE_TEXT);
      return 400;
    }
    if (!RegExpConstants.emailRegExp.hasMatch(syncFamilyEmail.email)) {
      Fluttertoast.showToast(msg: 'メールアドレスの形式が正しくありません');
      return 400;
    }
    ProtectorNotifier().enableProtector();
    String? iconImageUrl;
    if (syncFamilyEmail.avatar != null && syncFamilyEmail.avatar!.isNotEmpty) {
      String fileName = syncFamilyEmail.familyEmailId;
      File imageFile = await _imageUtilsService.uint8listToFile(
          syncFamilyEmail.avatar!, fileName);
      iconImageUrl = await _cloudStorageService.uploadFamilyEmailAvatar(
        UserData().user!.userId,
        syncFamilyEmail.familyEmailId,
        imageFile,
      );
    }
    FamilyEmailPostRequest body = FamilyEmailPostRequest(
      iconImageUrl: iconImageUrl,
      familyEmailId: syncFamilyEmail.familyEmailId,
      firstName: syncFamilyEmail.firstName,
      lastName: syncFamilyEmail.lastName,
      email: syncFamilyEmail.email,
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
