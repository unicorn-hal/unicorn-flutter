import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class MedicineView extends StatelessWidget {
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    List<Map<String, dynamic>> reminderList = [
      {
        'name': 'カロナール',
        'week': '毎日曜日',
        'reminder': [
          '13:00',
        ]
      },
      {
        'name': 'ロキソニン',
        'week': '毎月曜日',
        'reminder': [
          '06:00',
          '11:00',
          '15:00',
          '19:00',
          '23:00',
        ]
      },
      {'name': 'ボルタレン錠', 'week': '', 'reminder': []},
      {
        'name': 'メキシチールカプセル50mg',
        'week': '日,月,火,水,木,金',
        'reminder': [
          '19:00',
        ]
      },
      {'name': 'メインテート錠', 'week': '', 'reminder': []},
      {
        'name': 'ファスティック錠30',
        'week': '毎金曜日',
        'reminder': [
          '11:00',
        ]
      },
      {
        'name': 'サーティカン錠0.5mg',
        'week': '火,水',
        'reminder': [
          '09:00',
          '12:00',
          '19:00',
        ]
      },
    ];
    // todo: ↑形全然違うけどcontroller出来たら変えるので気にしないで
    // List<Map<String, dynamic>> reminderList = [];

    // todo: controller出来たら移動
    return CustomScaffold(
      body: SizedBox(
        width: deviceWidth,
        height: deviceHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: deviceHeight * 0.5,
              width: deviceWidth * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: deviceWidth * 0.9,
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 5,
                              ),
                              child: CustomText(text: 'Myおくすり'),
                            ),
                          ),
                          Visibility(
                            visible: reminderList.isNotEmpty,
                            child: Expanded(
                              flex: 1,
                              child: GestureDetector(
                                // IconButtonにすると勝手に上下のスペースを持ちやがるので渋々GestureDetector(Icon)
                                onTap: () {
                                  const ProfileMedicineSettingRoute()
                                      .push(context);
                                  // todo: リマインダー画面へ
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    reminderList.isNotEmpty
                        ? SizedBox(
                            width: deviceWidth * 0.9,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: reminderList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CommonItemTile(
                                  title: reminderList[index]['name'],
                                  onTap: () {
                                    const ProfileMedicineSettingRoute()
                                        .push(context);
                                    // todo: リマインダー画面へ
                                  },
                                  action:
                                      reminderList[index]['reminder'].isNotEmpty
                                          ? const Icon(
                                              Icons.notifications,
                                              color: Colors.blue,
                                            )
                                          : const Icon(
                                              Icons.notifications_off_outlined,
                                              color: Colors.grey,
                                            ),
                                );
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () {
                                const ProfileMedicineSettingRoute()
                                    .push(context);
                                // todo: リマインダー画面へ
                              },
                              child: DottedBorder(
                                dashPattern: const [15, 10],
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(20),
                                child: SizedBox(
                                  width: deviceWidth * 0.9,
                                  height: 200,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.grey,
                                        size: 22,
                                      ),
                                      CustomText(
                                        text: 'おくすりを登録する',
                                        color: ColorName.textGray,
                                        fontSize: 14,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
              ),
              child: Container(
                width: deviceWidth * 0.9,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 149, 207, 255),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                          ),
                          CustomText(text: 'おくすりについて'),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: CustomText(
                          text: '・おくすり登録をして使える機能の説明①',
                          fontSize: 14,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: CustomText(
                          text: '・おくすり登録をして使える機能の説明②',
                          fontSize: 14,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: CustomText(
                          text: '・おくすり登録をして使える機能の説明③',
                          fontSize: 14,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: CustomText(
                          text: '・おくすり登録をして使える機能の説明④',
                          fontSize: 14,
                        ),
                      ),
                    ],
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
