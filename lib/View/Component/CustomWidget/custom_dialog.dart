import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.text,
    this.decision = true,
    this.image,
    this.titleColor = Colors.black,
    // todo: 決まり次第色変更
    this.onTap,
  });

  final String title;
  final String text;
  final bool decision;
  final Image? image;
  final Color titleColor;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      surfaceTintColor: Colors.white,
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: titleColor,
              ),
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomText(
                  text: title,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            Visibility(
              visible: image != null,
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                height: 120,
                child: image,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              width: 180,
              child: CustomText(
                text: text,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomButton(
                      text: 'キャンセル',
                      onTap: () {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop();
                      },
                      primaryColor: Colors.black,
                      // todo: 決まり次第色変更
                    ),
                  ),
                  decision
                      ? const SizedBox(
                          width: 20,
                        )
                      : Container(),
                  Visibility(
                    visible: decision,
                    child: Expanded(
                      flex: 1,
                      child: CustomButton(
                        text: '決定',
                        isFilledColor: true,
                        onTap: onTap ?? () {},
                        primaryColor: Colors.black,
                        // todo: 決まり次第色変更
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
