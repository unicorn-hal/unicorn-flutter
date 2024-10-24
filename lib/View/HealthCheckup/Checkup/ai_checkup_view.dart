import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

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
              child: SizedBox(
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: size.width * 0.15,
                      backgroundColor: Colors.yellow,
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: size.width,
                  child: Center(
                    child: CustomText(
                      text:
                          'あああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああああ',
                      fontSize: 18,
                      color: ColorName.textGray,
                      textOverflow: TextOverflow.ellipsis,
                      maxLine: 5,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: size.width,
                decoration: const BoxDecoration(
                  color: const Color.fromARGB(255, 252, 140, 132),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    topRight: Radius.circular(100),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      child: CircleButton(
                        buttonSize: 80,
                        buttonColor: Colors.red,
                        onTap: () {},
                        icon: const Icon(
                          Icons.mic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
