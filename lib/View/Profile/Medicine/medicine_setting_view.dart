import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_drum_roll.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class MedicineSettingView extends StatefulWidget {
  const MedicineSettingView({super.key});

  @override
  State<MedicineSettingView> createState() => _MedicineSettingViewState();
}

class _MedicineSettingViewState extends State<MedicineSettingView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController();
  bool registration = true;
  bool repeat = false;
  String repeatWeek = '月,火,水,木,金,土';
  List<String> reminderList = [];
  int? selectedItem = 1;

  List<Map<String, dynamic>> repeatWeekList = [
    {'name': '毎日曜日', 'check': false},
    {'name': '毎月曜日', 'check': false},
    {'name': '毎火曜日', 'check': false},
    {'name': '毎水曜日', 'check': false},
    {'name': '毎木曜日', 'check': false},
    {'name': '毎金曜日', 'check': false},
    {'name': '毎土曜日', 'check': false},
  ];
  // todo: controller出来たら削除
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return CustomScaffold(
      appBar: CustomAppBar(
        title: '常備薬の登録',
        foregroundColor: Colors.white,
        backgroundColor: ColorName.mainColor,
        actions: registration
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // todo: controller出来たら削除処理追加
                  },
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                ),
              ]
            : null,
      ),
      body: SizedBox(
        width: deviceWidth,
        height: deviceHeight,
        child: Column(
          children: [
            SizedBox(
              height: deviceHeight * 0.7,
              width: deviceWidth * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                          ),
                          child: CustomText(text: 'おくすりの名称'),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 70,
                      child: CustomTextfield(
                        hintText: '20文字以内で入力してください',
                        controller: nameController,
                        height: 50,
                        maxLines: 1,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: deviceWidth * 0.4,
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 5,
                                ),
                                child: CustomText(text: 'おくすりの量'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 30,
                              ),
                              child: SizedBox(
                                width: deviceWidth * 0.4,
                                height: 70,
                                child: CustomTextfield(
                                  hintText: '1 ~ 100(錠)',
                                  controller: countController,
                                  height: 50,
                                  maxLines: 1,
                                  number: true,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: deviceWidth * 0.1,
                        ),
                        Column(
                          children: [
                            Container(
                              width: deviceWidth * 0.4,
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 20,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  left: 5,
                                ),
                                child: CustomText(text: '1回の服用量'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 30,
                              ),
                              child: SizedBox(
                                width: deviceWidth * 0.4,
                                height: 70,
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 15,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                        width: 1,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 1,
                                      child: CustomText(text: '1'),
                                    ),
                                    DropdownMenuItem(
                                      value: 2,
                                      child: CustomText(text: '2'),
                                    ),
                                    DropdownMenuItem(
                                      value: 3,
                                      child: CustomText(text: '3'),
                                    ),
                                    DropdownMenuItem(
                                      value: 4,
                                      child: CustomText(text: '4'),
                                    ),
                                    DropdownMenuItem(
                                      value: 5,
                                      child: CustomText(text: '5'),
                                    ),
                                    DropdownMenuItem(
                                      value: 6,
                                      child: CustomText(text: '6'),
                                    ),
                                    DropdownMenuItem(
                                      value: 7,
                                      child: CustomText(text: '7'),
                                    ),
                                    DropdownMenuItem(
                                      value: 8,
                                      child: CustomText(text: '8'),
                                    ),
                                    DropdownMenuItem(
                                      value: 9,
                                      child: CustomText(text: '9'),
                                    ),
                                    DropdownMenuItem(
                                      value: 10,
                                      child: CustomText(text: '10'),
                                    ),
                                  ],
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedItem = value;
                                    });
                                  },
                                  value: selectedItem,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                          ),
                          child: CustomText(text: 'リマインダーを設定'),
                        ),
                        IconButton(
                          onPressed: () {
                            if (reminderList.length < 5) {
                              reminderList.add('a');
                              setState(() {});
                            }
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.blue,
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: reminderList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (reminderList.isEmpty) {
                              return Container();
                            }
                            return Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    reminderList.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                                CustomDrumRoll(
                                  showTime: true,
                                  reservation: DateTime.now(),
                                  // todo: リマインダー設定がすでにある場合reservationに入れる
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      // todo: ここだけ別State持ちたい
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          width: deviceWidth,
                                          margin:
                                              const EdgeInsets.only(top: 64),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 10,
                                                    ),
                                                    width: deviceWidth * 0.9,
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: CustomText(
                                                        text: '繰り返し',
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: -13,
                                                    left: -16,
                                                    child: TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const CustomText(
                                                        text: '戻る',
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                width: deviceWidth * 0.9,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15,
                                                  ),
                                                  child: ListView.builder(
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        repeatWeekList.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return SizedBox(
                                                        width:
                                                            deviceWidth * 0.9,
                                                        child: CommonItemTile(
                                                          title: repeatWeekList[
                                                              index]['name'],
                                                          action:
                                                              repeatWeekList[
                                                                          index]
                                                                      ['check']!
                                                                  ? const Icon(
                                                                      Icons
                                                                          .check,
                                                                      color: Colors
                                                                          .blue,
                                                                    )
                                                                  : null,
                                                          onTap: () {
                                                            repeatWeekList[
                                                                        index]
                                                                    ['check'] =
                                                                !repeatWeekList[
                                                                        index]
                                                                    ['check'];
                                                            // todo: controller出来たら変更
                                                            setState(() {});
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: ColorName.drumRollButtonColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: repeat
                                        ? CustomText(
                                            text: repeatWeek,
                                            color: Colors.blue,
                                          )
                                        : const CustomText(
                                            text: '繰り返し: 未設定',
                                            color: Colors.blue,
                                          ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              child: CustomButton(
                text: '保存',
                onTap: () {
                  Navigator.pop(context);
                },
                isFilledColor: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
