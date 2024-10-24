import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:unicorn_flutter/View/Profile/Medicine/medicine_setting_view.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class MyMedicineView extends StatelessWidget {
  const MyMedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    List<String> medicineNames = [
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
      'カロナール',
    ];
    List<String> reminderTime = [
      '午前12:00',
      '毎日午前8時',
      '木曜午後6時',
      '金曜午後9時',
      '火曜午前12時',
      '毎日午前8時',
      '木曜午後6時',
      '金曜午後9時',
      '火曜午前12時',
      '毎日午前8時',
      '木曜午後6時',
      '金曜午後9時',
      '火曜午前12時',
      '毎日午前8時',
      '木曜午後6時',
      '金曜午後9時',
      '火曜午前12時',
      '毎日午前8時',
      '木曜午後6時',
      '金曜午後9時',
      '火曜午前12時',
      '毎日午前8時',
      '木曜午後6時',
      '金曜午後9時',
    ];
    // List<String> medicineNames = [];
    // List<String> reminderTime = [];
    bool notification = false;

    // todo: controller出来たら移動
    return CustomScaffold(
      isScrollable: true,
      body: SizedBox(
        width: deviceWidth,
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
                    visible: medicineNames.isNotEmpty,
                    child: Expanded(
                      flex: 1,
                      child: GestureDetector(
                        // IconButtonにすると勝手に上下のスペースを持ちやがるので渋々GestureDetector(Icon)
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return RegularMedicineSettingView();
                            }),
                          );
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
            medicineNames.isNotEmpty
                ? SizedBox(
                    width: deviceWidth * 0.9,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: medicineNames.length,
                      itemBuilder: (BuildContext context, int index) {
                        return CommonItemTile(
                          title: medicineNames[index],
                          onTap: () {
                            // todo: リマインダー画面へ
                          },
                          tileHeight: 70,
                          action: notification
                              ? CustomText(
                                  text: reminderTime[index],
                                  color: ColorName.textGray,
                                  fontSize: 11,
                                )
                              : const Icon(
                                  Icons.notifications_none,
                                  // todo: 斜線付きに変更
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
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return RegularMedicineSettingView();
                          }),
                        );
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
            Padding(
              padding: const EdgeInsets.only(
                top: 170,
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
