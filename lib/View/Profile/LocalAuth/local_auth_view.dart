import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Profile/LocalAuth/local_auth_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';

class LocalAuthView extends StatefulWidget {
  const LocalAuthView({super.key});

  @override
  State<LocalAuthView> createState() => _LocalAuthViewState();
}

class _LocalAuthViewState extends State<LocalAuthView> {
  late LocalAuthController controller;
  bool isBiometrics = true;

  @override
  void initState() {
    super.initState();
    controller = LocalAuthController();
    controller.loadUseLocalAuth((useLocalAuth) {
      setState(() {
        isBiometrics = useLocalAuth;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

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
              action: isBiometrics
                  ? const Icon(
                      Icons.check,
                      color: Colors.blue,
                    )
                  : null,
              onTap: () {
                controller.updateUseLocalAuth(true, (value) {
                  setState(() {
                    isBiometrics = value;
                  });
                });
              },
            ),
            const SpacerAndDivider(),
            CommonItemTile(
              title: '設定しない',
              action: !isBiometrics
                  ? const Icon(
                      Icons.check,
                      color: Colors.blue,
                    )
                  : null,
              onTap: () {
                controller.updateUseLocalAuth(false, (value) {
                  setState(() {
                    isBiometrics = value;
                  });
                });
              },
            ),
            const SpacerAndDivider(),
          ],
        ),
      ),
    );
  }
}
