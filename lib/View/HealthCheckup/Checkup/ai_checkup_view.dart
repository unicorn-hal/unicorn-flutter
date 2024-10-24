import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class AiCheckupView extends StatelessWidget {
  const AiCheckupView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: size.width * 0.1,
                      backgroundColor: Colors.amber,
                      child: Assets.images.icons.aiIcon.image(),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomText(text: '体のことについて教えてください'),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.blue,
                width: size.width,
                child: CustomText(text: 'ここにチャットが表示されます'),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: size.width,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: CircleButton(
                      buttonSize: 10,
                      buttonColor: Colors.red,
                      onTap: () {},
                      icon: const Icon(
                        Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
