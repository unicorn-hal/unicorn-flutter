import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicorn_flutter/Constants/regexp_constants.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_info.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudStorage/cloud_storage_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/ImageUtils/image_utils_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class RegisterUserInfoController extends ControllerCore {
  FirebaseCloudStorageService get _cloudStorageService =>
      FirebaseCloudStorageService();
  ImageUtilsService get _imageUtilsService => ImageUtilsService();
  UserApi get _userApi => UserApi();

  RegisterUserInfoController({
    required super.from,
    required this.context,
  });

  BuildContext context;

  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController occupationTextController = TextEditingController();

  UserData userData = UserData();

  File? _imageFile;
  Image? _image;

  Image get image => _image ?? Assets.images.icons.defaultUserIcon.image();

  @override
  void initialize() {}

  Future<void> setTextEditingController() async {
    if (from == Routes.profile) {
      phoneNumberTextController.text = userData.user!.phoneNumber;
      emailTextController.text = userData.user!.email;
      occupationTextController.text = userData.user!.occupation;
    } else {
      return;
    }
  }

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
  Future<String?> _uploadImage() async {
    try {
      if (_imageFile == null) {
        return null;
      }
      ProtectorNotifier().enableProtector();
      String getUrl = await _cloudStorageService.uploadUserAvatar(
        UserData().user!.userId,
        _imageFile!,
      );
      return getUrl;
    } catch (e) {
      Log.echo('Failed to upload image: $e');
    } finally {
      ProtectorNotifier().disableProtector();
    }
    return null;
  }

  Future<void> submit(UserRequest userRequest) async {
    String? iconImageUrl;
    if (_imageFile != null) {
      iconImageUrl = await _uploadImage();
    }

    if (validateField() == false) {
      return;
    }

    UserInfo userInfo = UserInfo(
      iconImageUrl: iconImageUrl,
      phoneNumber: phoneNumberTextController.text,
      email: emailTextController.text,
      occupation: occupationTextController.text,
    );

    if (from == Routes.profile) {
      userRequest = UserRequest(
        userId: userData.user!.userId,
        firstName: userData.user!.firstName,
        lastName: userData.user!.lastName,
        email: userInfo.email,
        gender: userData.user!.gender,
        birthDate: userData.user!.birthDate,
        address: userData.user!.address,
        postalCode: userData.user!.postalCode,
        phoneNumber: userInfo.phoneNumber,
        iconImageUrl: userInfo.iconImageUrl,
        bodyHeight: userData.user!.bodyHeight,
        bodyWeight: userData.user!.bodyWeight,
        occupation: userInfo.occupation,
      );
      ProtectorNotifier().enableProtector();
      int responceCode = await _userApi.putUser(
          userId: userData.user!.userId, body: userRequest);
      ProtectorNotifier().disableProtector();
      if (responceCode == 400 || responceCode == 500) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        ProfileRoute().push(context);
        return;
      }
      // シングルトンに登録した値をセットする
      userData.setUser(User.fromJson(userRequest.toJson()));
      Fluttertoast.showToast(msg: Strings.PROFILE_EDIT_COMPLETED_MESSAGE);
      ProfileRoute().push(context);
      return;
    }

    userRequest.userId = userData.user!.userId;
    userRequest.iconImageUrl = userInfo.iconImageUrl;
    userRequest.phoneNumber = userInfo.phoneNumber;
    userRequest.email = userInfo.email;
    userRequest.occupation = userInfo.occupation;

    ProtectorNotifier().enableProtector();
    int responceCode = await _userApi.postUser(body: userRequest);
    ProtectorNotifier().disableProtector();
    if (responceCode == 400 || responceCode == 500) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    Fluttertoast.showToast(msg: Strings.PROFILE_REGISTRATION_COMPLETED_MESSAGE);
    HomeRoute().push(context);
  }

  bool validateField() {
    List<String> emptyMessageField = [];
    phoneNumberTextController.text.isEmpty
        ? emptyMessageField.add("電話番号")
        : null;
    emailTextController.text.isEmpty ? emptyMessageField.add("メールアドレス") : null;
    occupationTextController.text.isEmpty ? emptyMessageField.add("職業") : null;

    if (emptyMessageField.isNotEmpty) {
      Fluttertoast.showToast(msg: "${emptyMessageField.join(',')}が入力されていません。");
      return false;
    }
    if (!RegExpConstants.emailRegExp.hasMatch(emailTextController.text)) {
      Fluttertoast.showToast(msg: "メールアドレスの形式が正しくありません");
    }
    return true;
  }
}
