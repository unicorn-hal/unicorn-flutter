import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Profile/Medicine/medicine_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class MedicineView extends StatelessWidget {
  const MedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    // todo: 薬追加されたら表示画面を更新させる処理追加予定
    MedicineController controller = MedicineController();
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
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
                child: FutureBuilder<List<Medicine>?>(
                  future: controller.getMedicineList(),
                  builder: (context, AsyncSnapshot<List<Medicine>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: deviceWidth * 0.9,
                            height: 48,
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 5,
                                ),
                                child: CustomText(text: 'Myおくすり'),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: CustomLoadingAnimation(
                              text: 'ローディング中',
                              iconColor: Colors.grey,
                              textColor: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }
                    if (!snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: deviceWidth * 0.9,
                            height: 48,
                            padding: const EdgeInsets.only(
                              top: 10,
                            ),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: 5,
                                ),
                                child: CustomText(text: 'Myおくすり'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: GestureDetector(
                              onTap: () {
                                const ProfileMedicineSettingRoute()
                                    .push(context);
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
                      );
                    }
                    List<Medicine> medicineList = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: deviceWidth * 0.9,
                          height: 48,
                          padding: const EdgeInsets.only(
                            top: 10,
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
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () {
                                    const ProfileMedicineSettingRoute()
                                        .push(context);
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: deviceWidth * 0.9,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: medicineList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CommonItemTile(
                                title: medicineList[index].medicineName,
                                onTap: () {
                                  ProfileMedicineSettingRoute(
                                    $extra: medicineList[index],
                                  ).push(context);
                                },
                                action: medicineList[index].reminders.isNotEmpty
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
                        ),
                      ],
                    );
                  },
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
                  color: ColorName.medicineExplanationColor,
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
