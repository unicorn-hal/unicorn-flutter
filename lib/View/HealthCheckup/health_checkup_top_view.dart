import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_result_enum.dart';
import 'package:unicorn_flutter/Controller/HealthCheckup/health_checkup_top_contoller.dart';
import 'package:unicorn_flutter/Model/Data/HealthCheckup/health_checkup_data.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/HealthCheck/health_past_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/health_check_button.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class HealthCheckupTopView extends ConsumerWidget {
  const HealthCheckupTopView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final Size size = MediaQuery.of(context).size;
    final HealthCheckupData healthCheckupData =
        ref.watch(healthCheckupDataProvider);
    final HealthCheckupTopController controller = HealthCheckupTopController();

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
          controller.alreadyCheackup
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
                                      text: DateFormat('yyyy年MM月dd日').format(
                                          controller.todayHealthCheckup!.date),
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
                                                  text:
                                                      '${controller.todayHealthCheckup!.bodyTemperature} ℃',
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
                                                  text:
                                                      '${controller.todayHealthCheckup!.bloodPressure} mmhg',
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
                                  const CustomText(
                                    text: '検診結果',
                                    fontSize: 12,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    child: CustomText(
                                      text: HealthCheckupResultType.typeTitle(
                                          controller.healthCheckupResult!),
                                      fontSize: 26,
                                      color: HealthCheckupResultType.typeColor(
                                          controller.healthCheckupResult!),
                                    ),
                                  ),
                                  CustomText(
                                    text:
                                        HealthCheckupResultType.typeDescription(
                                            controller.healthCheckupResult!),
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
                    items: [
                      HealthCheckButton(
                        onTap: () {
                          const CheckupResultRoute().push(context);
                        },
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 100,
                            child: HealthCheckButton(
                              onTap: () {
                                const AiCheckupRoute().push(context);
                              },
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
          healthCheckupData.data == null
              ? SizedBox(
                  height: 300,
                  width: size.width,
                  child: const Center(
                    child: CustomText(text: '過去の検診記録はありません。'),
                  ),
                )
              : ListView.builder(
                  itemCount: healthCheckupData.data!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  reverse: true,
                  itemBuilder: (context, index) {
                    return HealthPastTile(
                      timeDate: healthCheckupData.data![index].date,
                      bodyTemperature:
                          healthCheckupData.data![index].bodyTemperature,
                      bloodPressure:
                          healthCheckupData.data![index].bloodPressure,
                    );
                  },
                ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
