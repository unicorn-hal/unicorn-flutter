import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/Medicine/medicine_setting_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dropdown.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_drum_roll.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_modal.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class MedicineSettingView extends StatefulWidget {
  const MedicineSettingView({
    super.key,
    this.medicine,
  });
  final Medicine? medicine;

  @override
  State<MedicineSettingView> createState() => _MedicineSettingViewState();
}

class _MedicineSettingViewState extends State<MedicineSettingView> {
  late MedicineSettingController controller;
  @override
  void initState() {
    super.initState();
    controller = MedicineSettingController(widget.medicine);
  }

  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return CustomScaffold(
      focusNode: focusNode,
      appBar: CustomAppBar(
        title: 'おくすりの${widget.medicine != null ? '編集' : '登録'}',
        foregroundColor: Colors.white,
        backgroundColor: ColorName.mainColor,
        actions: widget.medicine != null
            ? [
                IconButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      builder: (_) {
                        return CustomDialog(
                          title: Strings.DIALOG_TITLE_CAVEAT,
                          bodyText: Strings.DIALOG_BODY_TEXT_DELETE,
                          rightButtonOnTap: () async {
                            ProtectorNotifier().enableProtector();
                            await controller.deleteMedicine();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            ProtectorNotifier().disableProtector();
                          },
                        );
                      },
                    );
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: deviceHeight * 0.65,
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
                          controller: controller.nameController,
                          height: 50,
                          maxLines: 1,
                          maxLength: 20,
                          width: deviceWidth * 0.9,
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
                                    controller: controller.countController,
                                    height: 50,
                                    maxLines: 1,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    maxLength: 3,
                                    width: deviceWidth * 0.4,
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
                                  child: CustomDropdown(
                                    dropdownItems: [
                                      for (int i = 0; i < 10; i++) ...{
                                        DropdownMenuItem(
                                          value: i,
                                          child: CustomText(
                                            text: '${i + 1}',
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      },
                                    ],
                                    height: 50,
                                    selectIndex: controller.selectIndex,
                                    onChanged: (int? value) {
                                      controller.setSelectIndex(value!);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
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
                                if (controller.reminders.length < 5) {
                                  controller.addReminders();
                                  setState(() {});
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'リマインダーは5件以上登録できません');
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
                              itemCount: controller.reminders.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (controller.reminders.isEmpty) {
                                  return Container();
                                }
                                return Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.deleteReminders(
                                            index: index);
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.remove_circle_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                    CustomDrumRoll(
                                      drumRollType: DrumRollType.time,
                                      splitMinute: 15,
                                      onConfirm: (DateTime date) {
                                        controller.updateReminderTime(
                                            date: date, index: index);
                                        Log.echo('date: $date');
                                      },
                                      initValue: controller.changeDateTime(
                                          index: index),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.copyReminderDayOfWeek(
                                            index: index);
                                        showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomModal(
                                              title: '繰り返し',
                                              leftButtonOnTap: () {
                                                controller
                                                    .resetReminderDayOfWeekList();
                                              },
                                              rightButtonOnTap: () {
                                                controller
                                                    .updateReminderDayOfWeek(
                                                        index: index);
                                                setState(() {});
                                              },
                                              content: StatefulBuilder(
                                                builder: (context,
                                                    StateSetter setState) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        width:
                                                            deviceWidth * 0.9,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 15,
                                                          ),
                                                          child:
                                                              ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: 7,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return SizedBox(
                                                                width:
                                                                    deviceWidth *
                                                                        0.9,
                                                                child:
                                                                    CommonItemTile(
                                                                  title:
                                                                      '毎${controller.getDayAbbreviation(index: index)}曜日',
                                                                  action: controller.checkReminderDayOfWeekList(
                                                                          index:
                                                                              index)
                                                                      ? const Icon(
                                                                          Icons
                                                                              .check,
                                                                          color:
                                                                              Colors.blue,
                                                                        )
                                                                      : null,
                                                                  onTap: () {
                                                                    controller.changeReminderDayOfWeekList(
                                                                        index:
                                                                            index);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: ColorName.drumRollButtonColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: CustomText(
                                          text: controller
                                              .moldingReminderDayOfWeek(
                                                  index: index),
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
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                width: deviceWidth * 0.9,
                child: CustomButton(
                  text: '保存',
                  onTap: () async {
                    if (!controller.validateField()) {
                      return;
                    }
                    ProtectorNotifier().enableProtector();
                    int res = widget.medicine != null
                        ? await controller.putMedicine()
                        : await controller.postMedicine();
                    ProtectorNotifier().disableProtector();
                    if (res != 200) {
                      return;
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  isFilledColor: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
