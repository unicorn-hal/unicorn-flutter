import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Controller/HealthCheckup/health_checkup_result_controller.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Package/UrlLauncher/url_launcher_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../Component/CustomWidget/custom_scaffold.dart';

class HealthCheckupResultsView extends StatelessWidget {
  const HealthCheckupResultsView(
      {super.key,
      required this.diseaseType,
      required this.healthPoint,
      required this.bloodPressure,
      required this.bodyTemperature});

  final HealthCheckupDiseaseEnum diseaseType;
  final int healthPoint;
  final String bloodPressure;
  final String bodyTemperature;

  @override
  Widget build(BuildContext context) {
    HealthCheckupResultController controller = HealthCheckupResultController(
      context,
      diseaseType,
      healthPoint,
      bloodPressure,
      bodyTemperature,
    );
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      isScrollable: true,
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Container(
                width: size.width,
                height: 300,
                color: controller.healthColor.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width,
                      height: 50,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: CustomText(
                                text: controller.formattedDate,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder(
                                  future: controller.getUserName(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return CustomText(
                                        text: snapshot.data!,
                                        fontSize: 14,
                                      );
                                    } else {
                                      return const SizedBox();
                                    }
                                  }),
                              const CustomText(
                                text: 'さんの検診結果',
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.9,
                      height: 100,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2.0,
                          ),
                          child: Container(
                            height: 80,
                            decoration: BoxDecoration(
                              color: controller.healthColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: CustomText(
                                text: controller.healthText,
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: CustomButton(
                          text: 'unicorn要請',
                          onTap: () {
                            const EmergencyRoute().push(context);
                          },
                          primaryColor: Colors.red,
                        )),
                    SizedBox(
                      width: size.width * 0.9,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: CustomText(
                              text: '異常が見られた内容',
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 70,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.diseaseTextList.length,
                              itemBuilder: (context, index) {
                                return CustomText(
                                  text: '・${controller.diseaseTextList[index]}',
                                  fontSize: 12,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: CustomText(text: '回答に関連する病気'),
              ),
            ),
            Container(
              width: size.width,
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              child: ListView.builder(
                itemCount: controller.diseaseExampleNameList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      UrlLauncherService().launchUrl(
                          'https://ja.wikipedia.org/wiki/${controller.diseaseExampleNameList[index]}');
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: size.width * 0.9,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorName.shadowGray,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: CustomText(
                                  text:
                                      controller.diseaseExampleNameList[index],
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.blue,
                                  size: 36,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
