import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';

class AppInformationView extends StatelessWidget {
  const AppInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    String version = '1.0.0';
    // todo: controller出来たら移動
    return CustomScaffold(
      body: SizedBox(
        width: deviceWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: deviceWidth * 0.9,
              padding: const EdgeInsets.only(
                left: 5,
                top: 20,
                bottom: 10,
              ),
              child: const CustomText(text: 'アプリ情報'),
            ),
            CommonItemTile(
              title: 'アプリをレビューする',
              onTap: () {
                // todo: controller出来たら変更
              },
            ),
            CommonItemTile(
              title: 'ライセンス',
              onTap: () {
                // todo: controller出来たら変更
              },
            ),
            CommonItemTile(
              title: 'プライバシーポリシー',
              onTap: () {
                // todo: controller出来たら変更
              },
            ),
            CommonItemTile(
              title: 'アプリバージョン',
              action: CustomText(
                text: version,
                color: Colors.grey,
                fontSize: 14,
              ),
              onTap: () {
                // todo: controller出来たら変更
              },
            ),
          ],
        ),
      ),
    );
  }
}
