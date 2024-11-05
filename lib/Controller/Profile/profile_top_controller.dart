import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Route/router.dart';

class ProfileTopController extends ControllerCore {
  /// Serviceのインスタンス化

  /// コンストラクタ
  ProfileTopController(
    this.context,
  );
  BuildContext context;

  /// 変数の定義
  List<Map<String, dynamic>> cellData = [
    {
      'title': 'アプリ情報',
      'icon': const Icon(Icons.info),
    },
    {
      'title': '持病設定',
      'icon': const Icon(Icons.sick),
    },
    {
      'title': '家族メール',
      'icon': const Icon(Icons.mail),
    },
    {
      'title': 'セキュリティ',
      'icon': const Icon(Icons.lock),
    },
    {
      'title': 'おくすり',
      'icon': const Icon(Icons.medical_services),
    },
    {
      'title': '通知設定',
      'icon': const Icon(Icons.notifications),
    },
    {
      'title': '身体情報',
      'icon': const Icon(Icons.man),
    },
    {
      'title': '住所設定',
      'icon': const Icon(Icons.home),
    },
    {
      'title': 'ユーザー設定',
      'icon': const Icon(Icons.manage_accounts),
    },
  ];

  /// initialize()
  @override
  void initialize() {
    print('Controller Init');
  }

  /// 各関数の実装

  void cellTap(int index) {
    switch (index) {
      case 0:
        const ProfileAppInformationRoute().push(context);
      case 1:
        const ProfileChronicDiseaseRoute().push(context);
      case 2:
        const ProfileFamilyEmailRoute().push(context);
      case 3:
        const ProfileLocalAuthRoute().push(context);
      case 4:
        const ProfileMedicineRoute().push(context);
      case 5:
        const ProfileNotificationSettingRoute().push(context);
      case 6:
        const ProfileRegisterPhysicalInfoRoute().push(context);
      case 7:
        const ProfileRegisterAddressInfoRoute().push(context);
      case 8:
        const ProfileRegisterUserInfoRoute().push(context);
    }
    return;
  }
}
