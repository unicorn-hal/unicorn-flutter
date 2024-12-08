// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Profile/profile_detail.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_notification.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/Service/Package/LocalAuth/local_auth_service.dart';
import 'package:unicorn_flutter/Service/Package/UrlLauncher/url_launcher_service.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class ProfileTopController extends ControllerCore {
  /// Serviceのインスタンス化
  UserApi get _userApi => UserApi();
  UrlLauncherService get _urlLauncherService => UrlLauncherService();
  LocalAuthService get _localAuthService => LocalAuthService();

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
          onTap: () async {
            if (await _localAuthService.getLocalAuthStatus() ==
                LocalAuthStatus.failed) {
              Fluttertoast.showToast(
                  msg: Strings.LOCAL_AUTH_NOT_AVAILABLE_TEXT);
              return;
            }
            const ProfileLocalAuthRoute().push(context);
          }),
      ProfileDetail(
          title: 'おくすり',
          icon: Icons.medical_services,
          onTap: () => const ProfileMedicineRoute().push(context)),
      ProfileDetail(
        title: '通知設定',
        icon: Icons.notifications,
        onTap: () async {
          ProtectorNotifier().enableProtector();
          UserNotification? userNotification = await getUserNotification();
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
          final UserRequest userRequest = UserData().getUserWithRequest();
          ProfileRegisterPhysicalInfoRoute(
            $extra: userRequest,
          ).push(context);
        },
      ),
      ProfileDetail(
          title: '住所設定',
          icon: Icons.home,
          onTap: () {
            final UserRequest userRequest = UserData().getUserWithRequest();
            ProfileRegisterAddressInfoRoute(
              $extra: userRequest,
            ).push(context);
          }),
      ProfileDetail(
          title: 'ユーザー設定',
          icon: Icons.manage_accounts,
          onTap: () {
            final UserRequest userRequest = UserData().getUserWithRequest();
            ProfileRegisterUserInfoRoute(
              $extra: userRequest,
            ).push(context);
          }),
      ProfileDetail(
        title: '問い合わせ',
        icon: Icons.question_mark,
        onTap: () async {
          await _urlLauncherService
              .launchUrl('https://forms.gle/YhZ2TMW3iXbAx4Vx5');
        },
      ),
      ProfileDetail(
          title: '通話予約',
          icon: Icons.call,
          onTap: () => const ProfileCallReservationRoute().push(context)),
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

  /// 各関数の実装
  // User getUser() {
  //   User user = ;
  //   return user;
  // }

  List<ProfileDetail> get cellData => _cellData;
}
