import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';

import '../../Component/CustomWidget/custom_scaffold.dart';

class HealthCheckupResultsView extends StatelessWidget {
  HealthCheckupResultsView({super.key});

  // todo: 状態を5段階に分けたenumを作成し、それを元に表示を変える。
  final Color healthColor = Colors.blue;
  final String healthText = '放置すると危険な症状や病気があります。\n設定された住所にunicornを緊急要請しました。';
  final List<String> sicks = [
    '頭痛の症状持続時間(1週間超)',
    '頭痛の出現時期',
    '頭痛の程度(日常生活に支障が出るレベル)',
  ];
  // todo: 病気のリストを取得する
  final List<String> diseases = [
    '脳腫瘍',
    '脳梗塞',
    '脳出血',
    '脳炎',
    '脳脊髄液減少症',
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      isScrollable: true,
      body: Center(
        child: Column(
          children: [
            /// 検診結果を表示する部分
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Container(
                width: size.width,
                height: 300,
                color: healthColor.withOpacity(0.5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width,
                      height: 50,
                      child: const Column(
                        // todo: controllerから取得
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: CustomText(
                                text: '10/10(土)',
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: 'のりた しおき',
                              ),
                              CustomText(
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
                              color: healthColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // todo: 症状によって文言を変えるor段階を５段階とかに分けてenumから表示する。
                            child: const Center(
                              child: CustomText(
                                text:
                                    '放置すると危険な症状や病気があります。\n設定された住所にunicornを緊急要請しました。',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: SpacerAndDivider(
                        topHeight: 10,
                        bottomHeight: 10,
                      ),
                    ),
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
                              itemCount: sicks.length,
                              itemBuilder: (context, index) {
                                return CustomText(
                                  text: '・${sicks[index]}',
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

            /// 関連する病気を表示する部分
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomText(text: '回答に関連する病気'),
              ),
            ),
            Container(
              width: size.width,
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              child: ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Center(
                    child: Container(
                      width: size.width * 0.9,
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      child: Center(
                        child: CustomText(
                          text: diseases[index],
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
