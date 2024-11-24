import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicorn_flutter/Constants/regexp_constants.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_post_request.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_put_request.dart';
import 'package:unicorn_flutter/Service/Api/FamilyEmail/family_email_api.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudStorage/cloud_storage_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/ImageUtils/image_utils_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:uuid/uuid.dart';

class FamilyEmailRegisterController extends ControllerCore {
  /// Serviceのインスタンス化
  FirebaseCloudStorageService get _cloudStorageService =>
      FirebaseCloudStorageService();
  ImageUtilsService get _imageUtilsService => ImageUtilsService();
  FamilyEmailApi get _familyEmailApi => FamilyEmailApi();

  /// コンストラクタ
  FamilyEmailRegisterController(this._familyEmail);
  final FamilyEmail? _familyEmail;

  /// 変数の定義
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? _imageFile;
  Image? _image;
  String? _iconImageUrl;
  late String _familyEmailId;

  /// initialize()
  @override
  void initialize() {
    if (_familyEmail != null) {
      lastNameController.text = _familyEmail.lastName;
      firstNameController.text = _familyEmail.firstName;
      emailController.text = _familyEmail.email;
      _iconImageUrl = _familyEmail.iconImageUrl;
      _familyEmailId = _familyEmail.familyEmailId;
    }
  }

  /// 各関数の実装
  Image? get image => (_image == null) && (_iconImageUrl == null)
      ? Assets.images.icons.defaultUserIcon.image()
      : _image;
  String? get iconImageUrl => _iconImageUrl;

  /// 端末のギャラリーから画像を選択する関数
  Future<void> selectImage() async {
    try {
      _imageFile = await _imageUtilsService.getImageFile(ImageSource.gallery);
      if (_imageFile == null) {
        return;
      }
      _image = await _imageUtilsService.fileToImage(_imageFile!);
    } catch (e) {
      Log.echo('Failed to select image: $e');
    }
  }

  /// 画像をCloud Storageにアップロードする関数
  Future<void> _uploadImage() async {
    try {
      if (_imageFile == null) {
        return;
      }
      _iconImageUrl = await _cloudStorageService.uploadFamilyEmailAvatar(
        UserData().user!.userId,
        _familyEmailId,
        _imageFile!,
      );
    } catch (e) {
      Log.echo('Failed to upload image: $e');
    }
  }

  /// メールアドレスを登録する関数
  Future<int> postFamilyEmail() async {
    ProtectorNotifier().enableProtector();
    _familyEmailId = const Uuid().v4();
    await _uploadImage();
    FamilyEmailPostRequest body = FamilyEmailPostRequest(
      familyEmailId: _familyEmailId,
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      iconImageUrl: _iconImageUrl,
    );
    int res = await _familyEmailApi.postFamilyEmail(
      body: body,
    );
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    ProtectorNotifier().disableProtector();
    return res;
  }

  /// メールアドレスを更新する関数
  Future<int> putFamilyEmail() async {
    ProtectorNotifier().enableProtector();
    await _uploadImage();
    FamilyEmailPutRequest body = FamilyEmailPutRequest(
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      iconImageUrl: _iconImageUrl,
    );
    int res = await _familyEmailApi.putFamilyEmail(
        body: body, familyEmailId: _familyEmailId);
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    ProtectorNotifier().disableProtector();
    return res;
  }

  /// メールアドレスを削除する関数
  Future<void> deleteFamilyEmail() async {
    ProtectorNotifier().enableProtector();
    int res =
        await _familyEmailApi.deleteFamilyEmail(familyEmailId: _familyEmailId);
    if (res != 204) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    ProtectorNotifier().disableProtector();
  }

  /// TextEditingControllerをvalidateする関数
  bool validateField() {
    if ((lastNameController.text == '') ||
        (firstNameController.text == '') ||
        (emailController.text == '')) {
      Fluttertoast.showToast(msg: Strings.FAMILY_EMAIL_VALIDATE_FIELD_TEXT);
      return false;
    }
    if (!RegExpConstants.emailRegExp.hasMatch(emailController.text)) {
      Fluttertoast.showToast(msg: Strings.FAMILY_EMAIL_VALIDATE_FORMAT_TEXT);
      return false;
    }
    return true;
  }
}
