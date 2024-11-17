import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_request.dart';
import 'package:unicorn_flutter/Service/Api/FamilyEmail/family_email_api.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudStorage/cloud_storage_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/ImageUtils/image_utils_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class FamilyEmailRegisterController extends ControllerCore {
  /// Serviceのインスタンス化
  FirebaseCloudStorageService get _cloudStorageService =>
      FirebaseCloudStorageService();
  ImageUtilsService get _imageUtilsService => ImageUtilsService();
  FamilyEmailApi get _familyEmailApi => FamilyEmailApi();

  /// コンストラクタ
  FamilyEmailRegisterController();

  /// 変数の定義
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? _imageFile;
  Image? _image;

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装
  Image get image => _image ?? Assets.images.icons.defaultUserIcon.image();

  /// 端末のギャラリーから画像を選択する
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

  /// 画像をCloud Storageにアップロードする
  Future<void> _uploadImage() async {
    try {
      if (_imageFile == null) {
        return;
      }
      ProtectorNotifier().enableProtector();
      await _cloudStorageService.uploadUserAvatar(
        UserData().user!.userId,
        _imageFile!,
      );
    } catch (e) {
      Log.echo('Failed to upload image: $e');
    } finally {
      ProtectorNotifier().disableProtector();
    }
  }

  Future<int> postFamilyEmail() async {
    if (!validateField()) {
      return 400;
    }
    ProtectorNotifier().enableProtector();
    FamilyEmailRequest body = FamilyEmailRequest(
      email: emailController.text,
      firstName: firstNameController.text,
      lastName: lastNameController.text,
    );
    int res = await _familyEmailApi.postFamilyEmail(body: body);
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    ProtectorNotifier().disableProtector();
    return res;
  }

  /// TextEditingControllerが空文字でないかチェックする関数
  bool validateField() {
    if ((lastNameController.text == '') ||
        (firstNameController.text == '') ||
        (emailController.text == '')) {
      Fluttertoast.showToast(msg: Strings.FAMILY_EMAIL_VALIDATE_TEXT);
      return false;
    }
    return true;
  }
}
