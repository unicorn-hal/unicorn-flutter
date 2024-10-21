import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class HealthCheckupTopView extends StatelessWidget {
  const HealthCheckupTopView({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 今日の検診結果・ボタン表示部
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
              width: size.width * 0.5,
              height: size.width * 0.1,
              child: const FittedBox(
                fit: BoxFit.contain,
                child: CustomText(
                  text: '今日の検診',
                ),
              ),
            ),
          ),
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
                  Container(
                    width: size.width,
                    height: 120,
                    child: Column(
                      children: [
                        SizedBox(
                          width: size.width,
                          height: 40,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: CustomText(text: '9月1日(土) 10:00'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width,
                          height: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: size.width * 0.3,
                                height: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: '体温',
                                            fontSize: 14,
                                          ),
                                          CustomText(
                                            text: '36.5℃',
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            text: '血圧',
                                            fontSize: 14,
                                          ),
                                          CustomText(
                                            text: '90/110 mmhg',
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
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: '検診結果',
                              fontSize: 12,
                            ),
                            CustomText(
                              text: '正常',
                              fontSize: 20,
                              color: Colors.green,
                            ),
                            CustomText(
                              text:
                                  '毎日の体温・血圧ともに平均値です。体調が優れない場合は医師との通話やAIチャットを利用してください',
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
          ),
        ],
      ),
    );
  }
}
