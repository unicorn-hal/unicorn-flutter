// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicorn_flutter/Constants/regexp_constants.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/Account/account_data.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_info.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_notification.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/Service/Firebase/CloudStorage/cloud_storage_service.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/ImageUtils/image_utils_service.dart';
import 'package:unicorn_flutter/Service/Package/LocalAuth/local_auth_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class RegisterUserInfoController extends ControllerCore {
  /// Serviceのインスタンス化
  FirebaseCloudStorageService get _cloudStorageService =>
      FirebaseCloudStorageService();
  ImageUtilsService get _imageUtilsService => ImageUtilsService();
  LocalAuthService get _localAuthService => LocalAuthService();
  UserApi get _userApi => UserApi();

  /// コンストラクタ
  RegisterUserInfoController({
    required super.from,
    required this.context,
  });
  BuildContext context;

  /// 変数の定義
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController occupationTextController = TextEditingController();
  bool _useAppbar = false;
  final UserData _userData = UserData();
  final ValueNotifier<bool> _protector = ValueNotifier(false);
  File? _imageFile;
  Image? _image;
  String? _iconImageUrl;

  /// initialize()
  @override
  void initialize() {
    _setDefaultValue();
  }

  /// 各関数の実装
  ValueNotifier<bool> get protector => _protector;
  Image? get image => (_image == null) && (_iconImageUrl == null)
      ? Assets.images.icons.defaultUserIcon.image()
      : _image;
  String? get iconImageUrl => _iconImageUrl;
  bool get useAppbar => _useAppbar;

  void _setDefaultValue() {
    if (from == Routes.profile) {
      _useAppbar = true;
      phoneNumberTextController.text = _userData.user!.phoneNumber;
      emailTextController.text = _userData.user!.email;
      occupationTextController.text = _userData.user!.occupation;
      _iconImageUrl = _userData.user!.iconImageUrl;
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
      String getUrl = await _cloudStorageService.uploadUserAvatar(
        AccountData().account!.uid,
        _imageFile!,
      );
      return getUrl;
    } catch (e) {
      Log.echo('Failed to upload image: $e');
    }
    return null;
  }

  /// ユーザー情報を登録する
  Future<void> _postUser(UserRequest userRequest) async {
    int statusCode = await _userApi.postUser(body: userRequest);
    if (statusCode != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      throw Exception('Failed to post user');
    }
    // シングルトンに登録した値をセットする
    _userData.setUser(User.fromJson(userRequest.toJson()));
    Fluttertoast.showToast(msg: Strings.PROFILE_REGISTRATION_COMPLETED_MESSAGE);
  }

  /// 通知設定を登録する
  Future<void> _postUserNotification() async {
    UserNotification? userNotification = await _userApi.postUserNotification(
      userId: _userData.user!.userId,
      body: UserNotification(
        isHospitalNews: true,
        isMedicineReminder: true,
        isRegularHealthCheckup: true,
      ),
    );
    if (userNotification == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      throw Exception('Failed to post user notification');
    }
  }

  /// ユーザー情報を更新する
  Future<void> _putUser(UserRequest userRequest) async {
    int statusCode = await _userApi.putUser(
        userId: _userData.user!.userId, body: userRequest);
    if (statusCode != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      throw Exception('Failed to put user');
    }
    // シングルトンに登録した値をセットする
    _userData.setUser(User.fromJson(userRequest.toJson()));
    Fluttertoast.showToast(msg: Strings.PROFILE_EDIT_COMPLETED_MESSAGE);
  }

  /// 登録ボタンを押した時の処理
  Future<void> submit(UserRequest userRequest) async {
    if (_validateField() == false) {
      return;
    }

    try {
      _protectorHandler(true);

      if (_imageFile != null) {
        _iconImageUrl = await _uploadImage();
      }

      UserInfo userInfo = UserInfo(
        iconImageUrl: _iconImageUrl,
        phoneNumber: phoneNumberTextController.text,
        email: emailTextController.text,
        occupation: occupationTextController.text,
      );

      userRequest.userId = AccountData().account!.uid;
      userRequest.iconImageUrl = userInfo.iconImageUrl;
      userRequest.phoneNumber = userInfo.phoneNumber;
      userRequest.email = userInfo.email;
      userRequest.occupation = userInfo.occupation;

      switch (from) {
        case Routes.registerAddressInfo: // 初回登録
          await _postUser(userRequest);
          await _postUserNotification();

          LocalAuthStatus localAuthStatus =
              await _localAuthService.getLocalAuthStatus();

          _protectorHandler(false);
          if (localAuthStatus == LocalAuthStatus.failed) {
            const HomeRoute().push(context);
          } else {
            const RegisterLocalAuthRoute().push(context);
          }

          break;
        case Routes.profile: // プロフィール編集
          if (_image == null &&
              _userData.user!.phoneNumber == phoneNumberTextController.text &&
              _userData.user!.email == emailTextController.text &&
              _userData.user!.occupation == occupationTextController.text) {
            _protectorHandler(false);
            const ProfileRoute().go(context);
            return;
          }
          await _putUser(userRequest);

          _protectorHandler(false);
          const ProfileRoute().go(context);
          break;
        default:
          break;
      }
    } catch (e) {
      _protectorHandler(false);
      Log.echo('Failed to submit: $e');
    }
  }

  bool _validateField() {
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
      return false;
    }
    return true;
  }

  /// プロテクターのハンドラー
  /// [value] プロテクターの値
  void _protectorHandler(bool value) {
    if (value) {
      if (from == Routes.profile) {
        ProtectorNotifier().enableProtector();
      } else {
        _protector.value = true;
      }
    } else {
      if (from == Routes.profile) {
        ProtectorNotifier().disableProtector();
      } else {
        _protector.value = false;
      }
    }
  }

  /// メモリリークを防ぐためdispose
  void dispose() {
    phoneNumberTextController.dispose();
    emailTextController.dispose();
    occupationTextController.dispose();
    _protector.dispose();
  }
}
