import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/HealthCheckup/Checkup/ai_checkup_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class AiCheckupView extends StatefulWidget {
  const AiCheckupView({super.key});

  @override
  State<AiCheckupView> createState() => _AiCheckupViewState();
}

class _AiCheckupViewState extends State<AiCheckupView> {
  late AiCheckupController controller;

  @override
  void initState() {
    super.initState();
    controller = AiCheckupController(context);
  }

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
                      child: Assets.images.icons.uniIcon.image(),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(text: '体のことについて教えてください'),
                      ),
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
                  child: Center(
                    child: ValueListenableBuilder<String>(
                        valueListenable: controller.aiText,
                        builder: (context, value, child) {
                          return CustomText(
                            text: value,
                            fontSize: 18,
                            color: ColorName.textGray,
                            textOverflow: TextOverflow.ellipsis,
                            maxLine: 5,
                          );
                        }),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: size.width,
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Center(
                    child: controller.isDone
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: CustomButton(
                                    text: 'もう一度',
                                    onTap: () {
                                      controller.resetRecording();
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: SizedBox(
                                  height: 50,
                                  width: 150,
                                  child: CustomButton(
                                    text: '検診結果へ',
                                    onTap: () {
                                      if (controller.textValidate()) {
                                        controller.navigateToCheckupResult();
                                      }
                                    },
                                    isFilledColor: true,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : AvatarGlow(
                            animate: controller.isListening,
                            glowColor: Colors.red,
                            glowRadiusFactor: 0.4,
                            child: GestureDetector(
                              // 音声認識の開始と停止
                              onTapDown: (value) {
                                controller.startListening();
                                setState(() {});
                              },
                              onTapUp: (value) {
                                controller.stopListening();
                                setState(() {});
                              },
                              child: const CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 48,
                                child: Icon(
                                  Icons.mic,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
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
