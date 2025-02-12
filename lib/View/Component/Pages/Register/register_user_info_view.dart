import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unicorn_flutter/Controller/Component/Pages/Register/register_user_info_controller.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/View/Component/Parts/field_title.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class RegisterUserInfoView extends StatefulWidget {
  const RegisterUserInfoView({
    super.key,
    this.userRequest,
    required this.from,
  });
  final UserRequest? userRequest;
  final String from;

  @override
  State<RegisterUserInfoView> createState() => _RegisterUserInfoViewState();
}

class _RegisterUserInfoViewState extends State<RegisterUserInfoView> {
  final FocusNode focusnode = FocusNode();

  late RegisterUserInfoController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RegisterUserInfoController(
      context: context,
      from: widget.from,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CustomScaffold(
          focusNode: focusnode,
          isAppbar: _controller.useAppbar,
          isScrollable: true,
          appBar: _controller.useAppbar
              ? CustomAppBar(
                  title: 'ユーザー情報',
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
                                    text: 'User',
                                    color: Colors.red,
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
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: FieldTitle(
                        title: 'プロフィール画像',
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
                                imageUrl: _controller.iconImageUrl,
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
                      child: FieldTitle(
                        title: '電話番号（ハイフンなし）',
                      ),
                    ),
                    CustomTextfield(
                      hintText: '01201234567',
                      width: deviceWidth * 0.85,
                      height: 44,
                      keyboardType: TextInputType.number,
                      controller: _controller.phoneNumberTextController,
                      maxLines: 1,
                      maxLength: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      child: FieldTitle(
                        title: 'メールアドレス',
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
                      child: FieldTitle(
                        title: '職業',
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
                            text: '保存する',
                            onTap: () async {
                              await _controller.submit(widget.userRequest!);
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
        ),
        ValueListenableBuilder(
            valueListenable: _controller.protector,
            builder: (context, value, child) {
              if (value == false) {
                return Container();
              }
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: LoadingAnimationWidget.fourRotatingDots(
                          color: Colors.amber,
                          size: 54,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            })
      ],
    );
  }
}
