import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';

class SecurityView extends StatelessWidget {
  const SecurityView({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    bool useFaceId = true;
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
              child: const CustomText(text: 'セキュリティ'),
            ),
            const SpacerAndDivider(
              topHeight: 0,
            ),
            CommonItemTile(
              title: 'Face IDを使う',
              action: Visibility(
                visible: useFaceId,
                child: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                useFaceId == !useFaceId;
                // todo: controller出来たら変更
              },
            ),
            const SpacerAndDivider(),
            CommonItemTile(
              title: '設定しない',
              action: Visibility(
                visible: !useFaceId,
                child: const Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
              ),
              onTap: () {
                useFaceId == !useFaceId;
                // todo: controller出来たら変更
              },
            ),
            const SpacerAndDivider(),
          ],
        ),
      ),
    );
  }
}
