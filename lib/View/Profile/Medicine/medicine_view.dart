import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Controller/Profile/Medicine/medicine_controller.dart';
import 'package:unicorn_flutter/Model/Cache/Medicine/medicine_cache.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/register_content_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class MedicineView extends StatefulWidget {
  const MedicineView({super.key});

  @override
  State<MedicineView> createState() => _MedicineViewState();
}

class _MedicineViewState extends State<MedicineView> {
  late MedicineController controller;
  @override
  void initState() {
    super.initState();
    controller = MedicineController();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return CustomScaffold(
      appBar: CustomAppBar(
        title: 'Myおくすり',
        foregroundColor: Colors.white,
        backgroundColor: ColorName.mainColor,
      ),
      body: SizedBox(
        width: deviceWidth,
        height: deviceHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: deviceHeight * 0.5,
              width: deviceWidth,
              child: SingleChildScrollView(
                child: Consumer(
                  builder: (context, ref, _) {
                    final medicineCacheRef = ref.watch(medicineCacheProvider);
                    final List<Medicine> medicineList = medicineCacheRef.data;

                    if (medicineList.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: HeaderTitle(
                                title: '登録済みのおくすり',
                              ),
                            ),
                          ),
                          RegisterContentTile(
                            tileText: 'おくすりを登録する',
                            onTap: () {
                              const ProfileMedicineSettingRoute().push(context);
                            },
                          ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: deviceWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: HeaderTitle(
                                    title: '登録済みのおくすり',
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    const ProfileMedicineSettingRoute()
                                        .push(context)
                                        .then((value) => setState(() {}));
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: ColorName.subColor,
                                    size: 30,
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
                                        color: ColorName.subColor,
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
                          text: '・登録できるおくすりの名称は最大20字です',
                          fontSize: 13,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: CustomText(
                          text: '・登録できるおくすりの残量は最大100錠です',
                          fontSize: 13,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: CustomText(
                          text: '・登録できるリマインダーは最大5件です',
                          fontSize: 13,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: CustomText(
                          text: '・登録されたおくすりはホーム画面に表示されます',
                          fontSize: 13,
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
