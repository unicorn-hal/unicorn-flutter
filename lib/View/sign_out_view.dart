import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/sign_out_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class SignOutView extends StatefulWidget {
  const SignOutView({super.key});

  @override
  State<SignOutView> createState() => _SignOutViewState();
}

class _SignOutViewState extends State<SignOutView> {
  late SignOutController controller;

  @override
  void initState() {
    super.initState();
    controller = SignOutController();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbar: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.icons.uniIcon.image(
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            const CustomText(
              text: 'ご利用ありがとうございました。\n'
                  'またのご利用をお待ちしております。\n'
                  'アプリを終了してください。',
            ),
          ],
        ),
      ),
    );
  }
}
