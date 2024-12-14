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
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

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
          title: '通話予約',
          iconImage: Assets.images.icons.callReservationIcon
              .image(color: ColorName.mainColor),
          onTap: () => const ProfileCallReservationRoute().push(context)),
      ProfileDetail(
          title: 'おくすり',
          iconImage: Assets.images.icons.medicineIcon
              .image(color: ColorName.mainColor),
          onTap: () => const ProfileMedicineRoute().push(context)),
      ProfileDetail(
          title: '家族メール',
          iconImage: Assets.images.icons.familyEmailIcon
              .image(color: ColorName.mainColor),
          onTap: () => const ProfileFamilyEmailRoute().push(context)),
      ProfileDetail(
          title: '持病設定',
          iconImage: Assets.images.icons.chronicDiseaseIcon
              .image(color: ColorName.mainColor),
          onTap: () => const ProfileChronicDiseaseRoute().push(context)),
      ProfileDetail(
        title: '身体情報',
        iconImage: Assets.images.icons.physicalInfoIcon
            .image(color: ColorName.mainColor),
        onTap: () {
          final UserRequest userRequest = UserData().getUserWithRequest();
          ProfileRegisterPhysicalInfoRoute(
            $extra: userRequest,
          ).push(context);
        },
      ),
      ProfileDetail(
          title: '住所設定',
          iconImage: Assets.images.icons.addressInfoIcon
              .image(color: ColorName.mainColor),
          onTap: () {
            final UserRequest userRequest = UserData().getUserWithRequest();
            ProfileRegisterAddressInfoRoute(
              $extra: userRequest,
            ).push(context);
          }),
      ProfileDetail(
          title: 'ユーザー設定',
          iconImage: Assets.images.bottomNavBar.profile
              .image(color: ColorName.mainColor),
          onTap: () {
            final UserRequest userRequest = UserData().getUserWithRequest();
            ProfileRegisterUserInfoRoute(
              $extra: userRequest,
            ).push(context);
          }),
      ProfileDetail(
        title: 'セキュリティ',
        iconImage:
            Assets.images.icons.localAuthIcon.image(color: ColorName.mainColor),
        onTap: () async {
          if (await _localAuthService.getLocalAuthStatus() ==
              LocalAuthStatus.failed) {
            Fluttertoast.showToast(msg: Strings.LOCAL_AUTH_NOT_AVAILABLE_TEXT);
            return;
          }
          const ProfileLocalAuthRoute().push(context);
        },
      ),
      ProfileDetail(
        title: '通知設定',
        iconImage: Assets.images.icons.notificationSettingIcon
            .image(color: ColorName.mainColor),
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
        title: '問い合わせ',
        iconImage:
            Assets.images.icons.inquiryIcon.image(color: ColorName.mainColor),
        onTap: () async {
          await _urlLauncherService
              .launchUrl('https://forms.gle/YhZ2TMW3iXbAx4Vx5');
        },
      ),
      ProfileDetail(
          title: 'アプリ情報',
          iconImage: Assets.images.icons.informationIcon
              .image(color: ColorName.mainColor),
          onTap: () => const ProfileAppInformationRoute().push(context)),
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
