import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/HealthCheck/health_past_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/health_check_button.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class HealthCheckupTopView extends StatelessWidget {
  const HealthCheckupTopView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    // todo: 本来は当日に検診記録があるかどうかで判定する
    // todo: 検診データのモデルをnull許容で引数に持つ

    final bool enableHealthCheck = true;
    final DateTime timeDate = DateTime.now();
    final double bodyTemperature = 36.5;
    final String bloodPressure = '90/110';
    final String healthCheckResult = '正常';
    final String healthCheckComment =
        '毎日の体温・血圧ともに平均値です。体調が優れない場合は医師との通話やAIチャットを利用してください';
    return CustomScaffold(
      isScrollable: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 今日の検診結果・ボタン表示部
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomText(
              text: '今日の検診',
              fontSize: 20,
            ),
          ),

          /// 本日の検診記録があるかどうか
          enableHealthCheck
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: size.width,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: ColorName.shadowGray,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width,
                          height: 120,
                          child: Column(
                            children: [
                              SizedBox(
                                width: size.width,
                                height: 40,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: CustomText(
                                      text: DateFormat('yyyy年MM月dd日')
                                          .format(timeDate),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width,
                                height: 80,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.3,
                                      height: 100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.15,
                                            height: 90,
                                            child: const FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Icon(
                                                Icons.thermostat,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.15,
                                            height: 90,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const CustomText(
                                                  text: '体温',
                                                  fontSize: 14,
                                                ),
                                                CustomText(
                                                  text: '$bodyTemperature℃',
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * 0.5,
                                      height: 100,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.15,
                                            height: 90,
                                            child: const FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Icon(
                                                Icons.bloodtype,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            height: 90,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const CustomText(
                                                  text: '血圧',
                                                  fontSize: 14,
                                                ),
                                                CustomText(
                                                  text: '$bloodPressure mmhg',
                                                  fontSize: 14,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width,
                          height: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // todo: 検診結果を反映する
                                  const CustomText(
                                    text: '検診結果',
                                    fontSize: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: CustomText(
                                      text: healthCheckResult,
                                      fontSize: 26,
                                      color: Colors.green,
                                    ),
                                  ),
                                  CustomText(
                                    text: healthCheckComment,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              :

              /// 本日の検診記録がない場合はへッダー画像を表示
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 3 / 2,
                    child: Assets.images.healthCheckupHeader.image(
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

          /// 検診を開始するボタン(通常検診&AI音声検診)
          Center(
            child: SizedBox(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: CustomText(text: '↓さあ、検診を開始しましょう↓'),
                  ),
                  CarouselSlider(
                    // todo: 検診の処理を後から追加
                    items: [
                      HealthCheckButton(
                        onTap: () {},
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 100,
                            child: HealthCheckButton(
                              onTap: () {},
                              aiCheck: true,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: SizedBox(
                              width: 100,
                              height: 60,
                              child: Assets.images.healthCheckupMark.image(
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    options: CarouselOptions(
                      height: 100,
                      initialPage: 0,
                      autoPlay: false,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: true,
                      autoPlayInterval: const Duration(seconds: 1),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SpacerAndDivider(),

          ///過去の検診結果表示部
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomText(
              text: '過去の検診',
              fontSize: 20,
            ),
          ),
          ListView.builder(
            // todo: controllerから値を取得する
            itemCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return HealthPastTile(
                timeDate: DateTime.now(),
                bodyTemperature: 36.5,
                bloodPressure: '90/110',
              );
            },
          )
        ],
      ),
    );
  }
}
