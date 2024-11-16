import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudStorage/cloud_storage_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/ImageUtils/image_utils_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class RegisterUserInfoController extends ControllerCore {

  final TextEditingController phoneNumberTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController occupationTextController = TextEditingController();

  FirebaseCloudStorageService get _cloudStorageService =>
      FirebaseCloudStorageService();
  ImageUtilsService get _imageUtilsService => ImageUtilsService();

  File? _imageFile;
  Image? _image;

  Image get image => _image ?? Assets.images.icons.defaultUserIcon.image();

  @override
  void initialize() {}

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

  Future<void> submit() async {
    if (_imageFile != null) {
      await _uploadImage();
    }
    // todo: APIでユーザー情報を登録する処理を追加
  }

  bool validateField() {
    List<String> emptyMessageField = [];
    phoneNumberTextController.text.isEmpty
        ? emptyMessageField.add("電話番号")
        : null;
    emailTextController.text.isEmpty
        ? emptyMessageField.add("メールアドレス")
        : null;
    occupationTextController.text.isEmpty ? emptyMessageField.add("性別") : null;

    if (emptyMessageField.isNotEmpty) {
      Fluttertoast.showToast(msg: "${emptyMessageField.join(',')}が入力されていません。");
      return false;
    }
    return true;
  }
}
