import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/FamilyEmail/family_email_register_controller.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/View/Component/Parts/field_title.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class FamilyEmailRegisterView extends StatefulWidget {
  const FamilyEmailRegisterView({
    super.key,
    this.familyEmail,
  });
  final FamilyEmail? familyEmail;

  @override
  State<FamilyEmailRegisterView> createState() =>
      _FamilyEmailRegisterViewState();
}

class _FamilyEmailRegisterViewState extends State<FamilyEmailRegisterView> {
  late FamilyEmailRegisterController controller;
  final focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    controller = FamilyEmailRegisterController(widget.familyEmail);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return CustomScaffold(
      isScrollable: true,
      focusNode: focusNode,
      appBar: CustomAppBar(
        title: '連絡先を登録',
        foregroundColor: Colors.white,
        backgroundColor: ColorName.mainColor,
        actions: widget.familyEmail != null
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
                            await controller.deleteFamilyEmail();
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
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
                    localImage: controller.image,
                    imageUrl: controller.iconImageUrl,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleButton(
                      borderColor: Colors.grey,
                      borderWidth: 1.0,
                      buttonSize: 35,
                      buttonColor: Colors.white,
                      onTap: () async {
                        await controller.selectImage();
                        setState(() {});
                      },
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
                        child: FieldTitle(title: '姓'),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.43,
                        height: 60,
                        child: CustomTextfield(
                          hintText: '山田',
                          controller: controller.lastNameController,
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
                        child: FieldTitle(title: '名'),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.43,
                        height: 60,
                        child: CustomTextfield(
                          hintText: '太郎',
                          controller: controller.firstNameController,
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
                    child: FieldTitle(title: 'メールアドレス'),
                  ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    height: 60,
                    child: CustomTextfield(
                      hintText: 'sample@sample.com',
                      controller: controller.emailController,
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
                onTap: () async {
                  if (!controller.validateField()) {
                    return;
                  }
                  int res = widget.familyEmail == null
                      ? await controller.postFamilyEmail()
                      : await controller.putFamilyEmail();
                  if (res != 200) {
                    return;
                  }
                  // ignore: use_build_context_synchronously
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
