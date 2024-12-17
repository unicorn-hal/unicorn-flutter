import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorn_flutter/Constants/Enum/user_gender_enum.dart';
import 'package:unicorn_flutter/Controller/Component/Pages/Register/register_physical_info_controller.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_drum_roll.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/View/Component/Parts/field_title.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class RegisterPhysicalInfoView extends StatefulWidget {
  const RegisterPhysicalInfoView({
    super.key,
    required this.userRequest,
    required this.from,
  });

  final String from;
  final UserRequest userRequest;

  @override
  State<RegisterPhysicalInfoView> createState() =>
      _RegisterPhysicalInfoViewState();
}

class _RegisterPhysicalInfoViewState extends State<RegisterPhysicalInfoView> {
  late RegisterPhysicalInfoController _controller;

  final FocusNode focusnode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = RegisterPhysicalInfoController(
      context: context,
      from: widget.from,
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return CustomScaffold(
      focusNode: focusnode,
      isAppbar: _controller.useAppbar,
      isScrollable: true,
      appBar: _controller.useAppbar
          ? CustomAppBar(
              title: '身体情報',
              foregroundColor: Colors.white,
              backgroundColor: ColorName.mainColor,
            )
          : null,
      body: SafeArea(
        child: SizedBox(
          width: deviceWidth,
          child: FractionallySizedBox(
            widthFactor: 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: !_controller.useAppbar,
                  child: Container(
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
                              color: Colors.red,
                              fontSize: 24,
                            ),
                            CustomText(
                              text: '身体情報を入力してください',
                              color: ColorName.textBlack,
                              fontSize: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: FieldTitle(
                    title: 'お名前',
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
                        controller: _controller.lastNameTextController,
                        keyboardType: TextInputType.text,
                        width: deviceWidth * 0.4,
                        maxLines: 1,
                        maxLength: 10,
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: CustomTextfield(
                        hintText: '太郎',
                        height: 44,
                        controller: _controller.firstNameTextController,
                        keyboardType: TextInputType.text,
                        width: deviceWidth * 0.4,
                        maxLines: 1,
                        maxLength: 10,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: FieldTitle(
                    title: '性別',
                    icon: Icons.male,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CircleButton(
                          buttonSize: 90,
                          buttonColor: _controller.gender == UserGenderEnum.male
                              ? ColorName.menCirclebuttonColor
                              : ColorName.nocheckedCirclebuttonColor,
                          onTap: () {
                            _controller.setGender(UserGenderEnum.male);
                            setState(() {});
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
                            color: _controller.gender == UserGenderEnum.male
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
                              _controller.gender == UserGenderEnum.female
                                  ? ColorName.womenCirclebuttonColor
                                  : ColorName.nocheckedCirclebuttonColor,
                          onTap: () {
                            _controller.setGender(UserGenderEnum.female);
                            setState(() {});
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
                            color: _controller.gender == UserGenderEnum.female
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
                          buttonColor:
                              _controller.gender == UserGenderEnum.other
                                  ? ColorName.textGray
                                  : ColorName.nocheckedCirclebuttonColor,
                          onTap: () {
                            _controller.setGender(UserGenderEnum.other);
                            setState(() {});
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
                            color: _controller.gender == UserGenderEnum.other
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
                  child: FieldTitle(
                    title: '生年月日',
                    icon: Icons.calendar_today,
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: CustomDrumRoll(
                      maxDate: DateTime.now().subtract(
                        const Duration(days: 1),
                      ),
                      minDate: DateTime(1900, 1, 1),
                      initValue: _controller.birthDate,
                      drumRollType: DrumRollType.date,
                      onConfirm: (DateTime date) {
                        _controller.setBirthDate(date);
                        Log.echo('date: $date');
                      },
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 10),
                  child: FieldTitle(
                    title: '身長・体重',
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
                        maxLines: 1,
                        maxLength: 5,
                        controller: _controller.bodyHeightTextController,
                        width: deviceWidth * 0.4,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    SizedBox(
                      width: deviceWidth * 0.4,
                      child: CustomTextfield(
                        hintText: '体重(kg)',
                        height: 44,
                        maxLines: 1,
                        maxLength: 5,
                        controller: _controller.bodyWeightTextController,
                        width: deviceWidth * 0.4,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: SizedBox(
                      width: deviceWidth * 0.5,
                      height: 60,
                      child: CustomButton(
                        fontSize: 18,
                        isFilledColor: true,
                        text: widget.from == Routes.profile ? '保存する' : '次に進む',
                        onTap: () async {
                          await _controller.submit(widget.userRequest);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
