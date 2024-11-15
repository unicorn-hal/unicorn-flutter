import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/Profile/profile_detail.dart';
import 'package:unicorn_flutter/Route/router.dart';

class ProfileTopController extends ControllerCore {
  /// Serviceのインスタンス化

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
          onTap: () => const ProfileNotificationSettingRoute().push(context)),
      ProfileDetail(
          title: '身体情報',
          icon: Icons.man,
          onTap: () => const ProfileRegisterPhysicalInfoRoute().push(context)),
      ProfileDetail(
          title: '住所設定',
          icon: Icons.home,
          onTap: () {
            // return const ProfileRegisterAddressInfoRoute().push(context);
          }),
      // ProfileDetail(
      //     title: 'ユーザー設定',
      //     icon: Icons.manage_accounts,
      //     onTap: () => const ProfileRegisterUserInfoRoute().push(context)),
    ];
  }

  /// 各関数の実装
  // User getUser() {
  //   User user = ;
  //   return user;
  // }

  List<ProfileDetail> get cellData => _cellData;
}
