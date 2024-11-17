import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';

class FamilyEmailRegisterView extends StatefulWidget {
  const FamilyEmailRegisterView({super.key});

  @override
  State<FamilyEmailRegisterView> createState() =>
      _FamilyEmailRegisterViewState();
}

class _FamilyEmailRegisterViewState extends State<FamilyEmailRegisterView> {
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  // todo: todo: controller出来たらcontrollerに移動
  final focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    String imageUrl = 'aaaaaaaaaaaaaaaaaaaaaa';
    // todo: todo: controller出来たら削除
    return CustomScaffold(
      isScrollable: true,
      focusNode: focusNode,
      body: SizedBox(
        width: deviceWidth,
        height: deviceHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 30,
              ),
              child: Stack(
                children: [
                  UserImageCircle(
                    imageSize: 150,
                    imageUrl: imageUrl,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleButton(
                      borderColor: Colors.grey,
                      borderWidth: 1.0,
                      buttonSize: 35,
                      buttonColor: Colors.white,
                      onTap: () {},
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 10,
                          left: 10,
                        ),
                        child: CustomText(text: '姓'),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.43,
                        height: 60,
                        child: CustomTextfield(
                          hintText: '山田',
                          controller: lastNameController,
                          height: 50,
                          maxLines: 1,
                          width: deviceWidth * 0.43,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 10,
                          left: 10,
                        ),
                        child: CustomText(text: '名'),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.43,
                        height: 60,
                        child: CustomTextfield(
                          hintText: '太郎',
                          controller: firstNameController,
                          height: 50,
                          maxLines: 1,
                          width: deviceWidth * 0.43,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      left: 10,
                    ),
                    child: CustomText(text: 'メールアドレス'),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    height: 60,
                    child: CustomTextfield(
                      hintText: 'sample@sample.com',
                      controller: emailController,
                      height: 50,
                      maxLines: 1,
                      width: deviceWidth * 0.9,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 50,
              ),
              width: deviceWidth * 0.9,
              height: 100,
              child: CustomButton(
                text: '登録する',
                onTap: () {
                  Navigator.pop(context);
                },
                isFilledColor: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
