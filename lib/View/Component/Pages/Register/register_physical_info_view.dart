import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';
import 'package:unicorn_flutter/Controller/Component/Pages/Register/register_physical_info_controller.dart';
import 'package:unicorn_flutter/Model/Entity/User/physical_info.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_drum_roll.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class RegisterPhysicalInfoView extends StatefulWidget {
  const RegisterPhysicalInfoView({super.key});

  @override
  State<RegisterPhysicalInfoView> createState() =>
      _RegisterPhysicalInfoViewState();
}

class _RegisterPhysicalInfoViewState extends State<RegisterPhysicalInfoView> {
  late RegisterPhysicalInfoController controller;

  final FocusNode focusnode = FocusNode();
  // todo: Controllerが完成次第、ここに追記していきます。

  @override
  void initState() {
    controller = RegisterPhysicalInfoController();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return CustomScaffold(
      focusNode: focusnode,
      isAppbar: false,
      isScrollable: true,
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          child: FractionallySizedBox(
            widthFactor: 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: ColorName.textGray),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            CustomText(
                              text: 'Profile',
                              color: ColorName.profileInputBackgroundColor,
                              fontSize: 24,
                            ),
                            CustomText(
                              text: '身体情報を入力してください',
                              color: ColorName.textBlack,
                              fontSize: 24,
                            ),
                          ],
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: CustomText(
                    text: 'お名前',
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: CustomTextfield(
                        hintText: '山田',
                        height: 44,
                        controller: controller.firstNameTextController,
                        width: deviceWidth * 0.4,
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: CustomTextfield(
                        hintText: '太郎',
                        height: 44,
                        controller: controller.lastNameTextController,
                        width: deviceWidth * 0.4,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: CustomText(
                    text: '性別',
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CircleButton(
                          buttonSize: 90,
                          buttonColor: controller.gender == UserGenderEnum.male
                              ? ColorName.menCirclebuttonColor
                              : ColorName.nocheckedCirclebuttonColor,
                          onTap: () {
                            setState(() {
                              controller.gender = UserGenderEnum.male;
                            });
                          },
                          icon: const Icon(
                            Icons.person_outlined,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            text: '男性',
                            color: controller.gender == UserGenderEnum.male
                                ? ColorName.menCirclebuttonColor
                                : ColorName.nocheckedCirclebuttonColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CircleButton(
                          buttonSize: 90,
                          buttonColor:
                              controller.gender == UserGenderEnum.female
                                  ? ColorName.womenCirclebuttonColor
                                  : ColorName.nocheckedCirclebuttonColor,
                          onTap: () {
                            setState(() {
                              controller.gender = UserGenderEnum.female;
                            });
                          },
                          icon: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            text: '女性',
                            color: controller.gender == UserGenderEnum.female
                                ? ColorName.womenCirclebuttonColor
                                : ColorName.nocheckedCirclebuttonColor,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CircleButton(
                          buttonSize: 90,
                          buttonColor: controller.gender == UserGenderEnum.other
                              ? ColorName.textGray
                              : ColorName.nocheckedCirclebuttonColor,
                          onTap: () {
                            setState(() {
                              controller.gender = UserGenderEnum.other;
                            });
                          },
                          icon: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomText(
                            text: 'その他',
                            color: controller.gender == UserGenderEnum.other
                                ? ColorName.textGray
                                : ColorName.nocheckedCirclebuttonColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: CustomText(
                    text: '生年月日',
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: CustomDrumRoll(
                      initValue: controller.birthDate,
                      drumRollType: DrumRollType.date,
                      onConfirm: (DateTime date) {
                        controller.birthDate = date;
                        Log.echo('date: $date');
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: CustomText(
                    text: '身長・体重',
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: CustomTextfield(
                        hintText: '身長(cm)',
                        height: 44,
                        maxLines: 3,
                        controller: controller.bodyHeightTextController,
                        width: deviceWidth * 0.4,
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: CustomTextfield(
                        hintText: '体重(kg)',
                        height: 44,
                        maxLines: 3,
                        controller: controller.bodyWeightTextController,
                        width: deviceWidth * 0.4,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                          width: deviceWidth * 0.5,
                          height: 60,
                          color: ColorName.profileInputButtonColor,
                          child: const Center(
                            child: CustomText(
                              text: '次に進む',
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ),
                  onTap: () {
                    PhysicalInfo physicalInfo = controller.submit();
                  },
                  // todo: 次のViewができ次第ルーティングします。
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
