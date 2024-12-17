import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/AppInformation/app_information_controller.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class AppInformationView extends StatelessWidget {
  const AppInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    AppInformationController controller = AppInformationController();
    double deviceWidth = MediaQuery.of(context).size.width;
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'アプリ情報',
        foregroundColor: Colors.white,
        backgroundColor: ColorName.mainColor,
      ),
      body: SizedBox(
        width: deviceWidth,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<String>(
              future: controller.getAppVersion(),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CustomLoadingAnimation(
                    text: Strings.LOADING_TEXT,
                    iconColor: Colors.grey,
                    textColor: Colors.grey,
                  );
                }
                if (!snapshot.hasData) {
                  // todo: エラー時の処理
                  return Container();
                }
                String appVersion = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonItemTile(
                      title: 'アプリをレビューする',
                      onTap: () async {
                        await controller.openReview();
                      },
                    ),
                    CommonItemTile(
                      title: 'ライセンス',
                      onTap: () {
                        ProfileAppInformationLicenseRoute(
                                appVersion: appVersion)
                            .push(context);
                      },
                    ),
                    CommonItemTile(
                      title: 'プライバシーポリシー',
                      onTap: () async {
                        await controller.launchUrl(controller.privacyPolicyUrl);
                      },
                    ),
                    CommonItemTile(
                      title: 'アプリバージョン',
                      action: CustomText(
                        text: appVersion,
                        color: ColorName.textGray,
                        fontSize: 14,
                      ),
                    ),
                    CommonItemTile(
                      title: 'アプリを退会',
                      titleColor: Colors.red,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialog(
                                title: '退会',
                                bodyText: '本当にアプリを退会しますか？',
                                leftButtonText: 'いいえ',
                                rightButtonText: 'はい',
                                rightButtonOnTap: () async {
                                  await controller.unsubscribe(context);
                                },
                              );
                            });
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
