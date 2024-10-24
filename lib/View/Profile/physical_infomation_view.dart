import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class PhysicalInfomationView extends StatefulWidget {
  const PhysicalInfomationView({
    super.key
  });

  @override
  State<PhysicalInfomationView> createState() => _PhysicalInfomationViewState();
}

class _PhysicalInfomationViewState extends State<PhysicalInfomationView> {
  final TextEditingController firstname = TextEditingController();
  final TextEditingController secondname = TextEditingController();
  final TextEditingController datetime = TextEditingController();
  final TextEditingController taller = TextEditingController();
  final TextEditingController weight = TextEditingController();
  int checkInt = 0;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    // Controllerが完成次第、ここに追記していきます。
    return SizedBox(
      width: deviceWidth,
      height: deviceHeight,
      child: FractionallySizedBox(
        widthFactor: 0.85,
        heightFactor: 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: ColorName.textGray
                  ),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.only(bottom: 20),
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
                  )
                ),
              ),
            ),
            
            const CustomText(
              text: 'お名前',
              fontSize: 19,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: deviceWidth * 0.4,
                  child: CustomTextfield(
                    hintText: '山田',
                    height: 44,
                    controller: firstname,
                  ),
                ),
                SizedBox(
                  width: deviceWidth * 0.4,
                  child: CustomTextfield(
                    hintText: '太郎',
                    height: 44,
                    controller: secondname,
                  ),
                ),
              ],
            ),
            const CustomText(
              text: '性別',
              fontSize: 19,
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      CircleButton(
                        buttonSize: deviceWidth * 0.25,
                        buttonColor: checkInt == 1 ? ColorName.menCirclebuttonColor : ColorName.nocheckedCirclebuttonColor,
                        onTap: () {
                          setState(() {
                            checkInt = 1;
                          });
                        },
                        icon: const Icon(
                          Icons.man,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(
                          text: '男性',
                          color: ColorName.menCirclebuttonColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CircleButton(
                        buttonSize: deviceWidth * 0.25,
                        buttonColor: checkInt == 2 ? ColorName.womenCirclebuttonColor : ColorName.nocheckedCirclebuttonColor,
                        onTap: () {
                          setState(() {
                            checkInt = 2;
                          });
                        },
                        icon: const Icon(
                          Icons.woman,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(
                          text: '女性',
                          color: ColorName.womenCirclebuttonColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CircleButton(
                        buttonSize: deviceWidth * 0.25,
                        buttonColor: checkInt == 3 ? ColorName.textGray : ColorName.nocheckedCirclebuttonColor, 
                        onTap: () {
                          setState(() {
                            checkInt = 3;
                          });
                        },
                        icon: const Icon(
                          Icons.transgender,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomText(
                          text: 'その他',
                          color: ColorName.textGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const CustomText(
              text: '生年月日',
              fontSize: 19,
            ),
            SizedBox(
              width: deviceWidth * 0.4,
              child: CustomTextfield(
                hintText: '1991/02/02',
                height: 44,
                controller: datetime,
              ),
            ),
            const CustomText(
              text: '身長・体重',
              fontSize: 19,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: deviceWidth * 0.4,
                  child: CustomTextfield(
                    hintText: '身長',
                    height: 44,
                    controller: taller,
                  ),
                ),
                SizedBox(
                  width: deviceWidth * 0.4,
                  child: CustomTextfield(
                    hintText: '体重',
                    height: 44,
                    controller: weight,
                  ),
                ),
              ],
            ),
            GestureDetector(
              child: Container(
                color: ColorName.profileInputButtonColor,
                child: const CustomText(
                  text: '次に進む',
                  color: Colors.white,                  
                )
              ),
              onTap: () {},
              // 次のViewができ次第ルーティングします
            )
          ],
        ),
      ),
    );
  }
}