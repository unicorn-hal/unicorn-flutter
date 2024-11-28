// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/shared_preferences_keys_enum.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Profile/profile_detail.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_notification.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/Service/Package/SharedPreferences/shared_preferences_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class ProfileTopController extends ControllerCore {
  /// Serviceのインスタンス化
  UserApi get _userApi => UserApi();
  SharedPreferencesService get _sharedPreferencesService =>
      SharedPreferencesService();

  /// コンストラクタ
  ProfileTopController(
    this.context,
  );
  BuildContext context;

  /// 変数の定義
  late List<ProfileDetail> _cellData;

  /// initialize()
  @override
  void initialize() {
    _cellData = [
      ProfileDetail(
          title: 'アプリ情報',
          icon: Icons.info,
          onTap: () => const ProfileAppInformationRoute().push(context)),
      ProfileDetail(
          title: '持病設定',
          icon: Icons.sick,
          onTap: () => const ProfileChronicDiseaseRoute().push(context)),
      ProfileDetail(
          title: '家族メール',
          icon: Icons.mail,
          onTap: () => const ProfileFamilyEmailRoute().push(context)),
      ProfileDetail(
          title: 'セキュリティ',
          icon: Icons.lock,
          onTap: () => const ProfileLocalAuthRoute().push(context)),
      ProfileDetail(
          title: 'おくすり',
          icon: Icons.medical_services,
          onTap: () => const ProfileMedicineRoute().push(context)),
      ProfileDetail(
        title: '通知設定',
        icon: Icons.notifications,
        onTap: () async {
          UserNotification? userNotification;
          ProtectorNotifier().enableProtector();
          bool notificationInitialized =
              await _sharedPreferencesService.getBool(
                      SharedPreferencesKeysEnum.notificationInitialized.name) ??
                  false;
          if (notificationInitialized == false) {
            userNotification = await postUserNotification();
            if (userNotification == null) {
              _sharedPreferencesService.setBool(
                  SharedPreferencesKeysEnum.notificationInitialized.name,
                  false);
              return;
            }
            await _sharedPreferencesService.setBool(
                SharedPreferencesKeysEnum.notificationInitialized.name, true);
          } else {
            userNotification = await getUserNotification();
          }
          ProtectorNotifier().disableProtector();
          if (userNotification == null) {
            return;
          }
          ProfileNotificationSettingRoute($extra: userNotification)
              .push(context);
        },
      ),
      ProfileDetail(
        title: '身体情報',
        icon: Icons.man,
        onTap: () {
          User? data = UserData().user;
          if (data == null) {
            return;
          }
          UserRequest userRequest = UserRequest(
            userId: data.userId,
            firstName: data.firstName,
            lastName: data.lastName,
            email: data.email,
            gender: data.gender,
            birthDate: data.birthDate,
            address: data.address,
            postalCode: data.postalCode,
            phoneNumber: data.phoneNumber,
            iconImageUrl: data.iconImageUrl,
            bodyHeight: data.bodyHeight,
            bodyWeight: data.bodyWeight,
            occupation: data.occupation,
          );
          ProfileRegisterPhysicalInfoRoute(
            $extra: userRequest,
          ).push(context);
        },
      ),
      ProfileDetail(
          title: '住所設定',
          icon: Icons.home,
          onTap: () {
            ProfileRegisterAddressInfoRoute().push(context);
          }),
      ProfileDetail(
          title: 'ユーザー設定',
          icon: Icons.manage_accounts,
          onTap: () => ProfileRegisterUserInfoRoute().push(context)),
    ];
  }

  /// 通知設定を取得する関数
  Future<UserNotification?> getUserNotification() async {
    UserNotification? userNotification =
        await _userApi.getUserNotification(userId: UserData().user!.userId);
    if (userNotification == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    return userNotification;
  }

  /// 通知設定を登録する関数
  Future<UserNotification?> postUserNotification() async {
    UserNotification? userNotification = await _userApi.postUserNotification(
      userId: UserData().user!.userId,
      body: UserNotification(
        isHospitalNews: true,
        isMedicineReminder: true,
        isRegularHealthCheckup: true,
      ),
    );
    if (userNotification == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    return userNotification;
  }

  /// 各関数の実装
  // User getUser() {
  //   User user = ;
  //   return user;
  // }

  List<ProfileDetail> get cellData => _cellData;
}
