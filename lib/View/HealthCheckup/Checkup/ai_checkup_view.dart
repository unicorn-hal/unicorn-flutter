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
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: size.width * 0.15,
                      backgroundColor: Colors.white,
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
                child: SizedBox(
                  width: size.width,
                  child: const Center(
                    child: CustomText(
                      // todo: 音声認識したテキストを表示する
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
                  // todo: できれば音声波形で大きさを変化させたい、無理なら没
                  color: ColorName.shadowGray,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Center(
                    child: CircleButton(
                      buttonSize: 80,
                      buttonColor: Colors.red,
                      onTap: () {
                        // todo: 音声認識を開始する処理
                      },
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
