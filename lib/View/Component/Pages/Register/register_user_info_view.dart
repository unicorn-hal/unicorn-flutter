import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Component/Pages/Register/register_user_info_controller.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class RegisterUserInfoView extends StatefulWidget {
  const RegisterUserInfoView({super.key, this.userRequest});
  final UserRequest? userRequest;

  @override
  State<RegisterUserInfoView> createState() => _RegisterUserInfoViewState();
}

class _RegisterUserInfoViewState extends State<RegisterUserInfoView> {
  final FocusNode focusnode = FocusNode();

  late RegisterUserInfoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterUserInfoController();
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
                              text: 'User',
                              color: ColorName.profileInputBackgroundColor,
                              fontSize: 22,
                            ),
                            CustomText(
                              text: 'ユーザー情報を入力してください',
                              color: ColorName.textBlack,
                              fontSize: 22,
                            ),
                          ],
                        )),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: CustomText(
                    text: 'プロフィール画像',
                    fontSize: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 40),
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        children: [
                          UserImageCircle(
                            imageSize: 200,
                            localImage: _controller.image,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: CircleButton(
                              buttonSize: 50,
                              buttonColor: Colors.white,
                              borderColor:
                                  ColorName.imageSelectCirclebuttonColor,
                              onTap: () async {
                                await _controller.selectImage();
                                setState(() {});
                              },
                              icon: const Icon(Icons.edit_outlined),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: CustomText(
                    text: '電話番号（ハイフンなし）',
                    fontSize: 20,
                  ),
                ),
                CustomTextfield(
                  hintText: '01201234567',
                  width: deviceWidth * 0.85,
                  height: 44,
                  keyboardType: TextInputType.phone,
                  controller: _controller.phoneNumberTextController,
                  maxLines: 1,
                  maxLength: 12,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: CustomText(
                    text: 'メールアドレス',
                    fontSize: 20,
                  ),
                ),
                CustomTextfield(
                  hintText: 'hogehoge@gmail.com',
                  width: deviceWidth * 0.85,
                  height: 44,
                  controller: _controller.emailTextController,
                  maxLines: 1,
                  maxLength: 30,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 10),
                  child: CustomText(
                    text: '職業',
                    fontSize: 20,
                  ),
                ),
                CustomTextfield(
                  hintText: '会社員、主婦、学生など',
                  width: deviceWidth * 0.85,
                  height: 44,
                  controller: _controller.occupationTextController,
                  maxLines: 1,
                  maxLength: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    await _controller.submit(widget.userRequest!);
                    // todo: 次のViewができ次第ルーティングします。
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
