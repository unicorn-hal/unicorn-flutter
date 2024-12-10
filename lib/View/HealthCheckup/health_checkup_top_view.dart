import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_result_enum.dart';
import 'package:unicorn_flutter/Controller/HealthCheckup/health_checkup_top_contoller.dart';
import 'package:unicorn_flutter/Model/Cache/HealthCheckup/health_checkup_cache.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/HealthCheck/health_past_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';
import 'package:unicorn_flutter/View/Component/Parts/health_check_button.dart';
import 'package:unicorn_flutter/View/Component/Parts/image_banner.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../Model/Entity/HealthCheckUp/health_checkup.dart';

class HealthCheckupTopView extends StatelessWidget {
  const HealthCheckupTopView({super.key});

  @override
  Widget build(BuildContext context) {
    final HealthCheckupTopController controller = HealthCheckupTopController();
    final Size size = MediaQuery.of(context).size;

    return Consumer(builder: (context, ref, _) {
      final HealthCheckupCache healthCheckupData =
          ref.watch(healthCheckupCacheProvider);

      // 本日の健康診断結果を取得
      final HealthCheckup? todayHealthCheckup =
          controller.getTodayHealthCheckup();
      return CustomScaffold(
        isScrollable: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderTitle(title: '本日の検診'),

            /// 本日の検診記録があるかどうか
            if (todayHealthCheckup != null)
              Padding(
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
                                        .format(todayHealthCheckup.date),
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
                                                    '${todayHealthCheckup.bodyTemperature} ℃',
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
                                                    '${todayHealthCheckup.bloodPressure} mmhg',
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
                                    text: HealthCheckupResultType.title(
                                        controller
                                            .resultToEnum(todayHealthCheckup)),
                                    fontSize: 26,
                                    color: HealthCheckupResultType.color(
                                        controller
                                            .resultToEnum(todayHealthCheckup)),
                                  ),
                                ),
                                CustomText(
                                  text: HealthCheckupResultType.description(
                                      controller
                                          .resultToEnum(todayHealthCheckup)),
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
            else
              // 本日の検診記録がない場合はへッダー画像を表示
              Center(
                child: SizedBox(
                  width: size.width * 0.9,
                  child: ImageBanner(
                    image: Assets.images.healthCheckupHeader.image(),
                  ),
                ),
              ),

            /// 検診を開始するボタン(通常検診&AI音声検診)
            Center(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: CustomText(text: '↓さあ、検診を開始しましょう↓'),
                    ),
                    // 通常検診ボタン
                    SizedBox(
                      height: 80,
                      child: HealthCheckButton(
                        onTap: () {
                          const NormalCheckupRoute().push(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const HeaderTitle(title: 'AI検診'),

            /// AI検診ボタン
            ImageBanner(
              image: Assets.images.banner.aiCheckupBanner.image(),
              onTap: () {
                const AiCheckupRoute().push(context);
              },
            ),

            const SpacerAndDivider(),

            ///過去の検診結果表示部
            const HeaderTitle(title: '過去の検診'),
            healthCheckupData.data.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: ColorName.shadowGray,
                      ),
                      height: 300,
                      width: size.width,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(text: '検診記録がありません。'),
                            CustomText(text: '検診ボタンを押して記録を残しましょう!'),
                          ],
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: healthCheckupData.data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) {
                      return HealthPastTile(
                        timeDate: healthCheckupData.data[index].date,
                        bodyTemperature:
                            healthCheckupData.data[index].bodyTemperature,
                        bloodPressure:
                            healthCheckupData.data[index].bloodPressure,
                      );
                    },
                  ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    });
  }
}
