import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/top_loading_controller.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class TopLoadingView extends StatelessWidget {
  const TopLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    late TopLoadingController controller;
    try {
      controller = TopLoadingController(context);
    } catch (e) {
      Log.echo('TopLoading Error: $e', symbol: '❌');
    }
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: Assets.images.topLoadingBackground.provider(),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: deviceHeight,
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.images.topLoading.image(),
                const SizedBox(height: 16),
                LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.amber,
                  size: 54,
                ),
                const SizedBox(height: 16),
                const CustomText(
                  text: 'Loading ...',
                  fontWeight: FontWeight.w500,
                ),
                const SizedBox(height: 48),
                FutureBuilder(
                  future: controller.appVersion,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomText(
                        text: 'v${snapshot.data}',
                        color: ColorName.textGray,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                FutureBuilder(
                  future: controller.checkReleaseBuild(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      bool isReleaseBuild = snapshot.data!;
                      if (isReleaseBuild) {
                        return const SizedBox();
                      } else {
                        return Column(
                          children: [
                            const CustomText(
                              text: 'DEBUG BUILD',
                              color: ColorName.textGray,
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                            const SizedBox(height: 8),
                            CustomButton(
                              text: 'データ初期化',
                              onTap: () {
                                controller.clearData();
                              },
                            )
                          ],
                        );
                      }
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                const SizedBox(height: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (String message
                        in Strings.TOP_LOADING_CAUTION_TEXT_LIST)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: CustomText(
                          text: message,
                          fontSize: 10,
                          color: ColorName.textGray,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
