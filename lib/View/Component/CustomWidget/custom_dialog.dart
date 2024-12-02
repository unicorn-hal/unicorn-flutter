import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.bodyText,
    this.image,
    this.titleColor = ColorName.mainColor,
    this.leftButtonText = 'キャンセル',
    this.rightButtonText = '決定',
    this.leftButtonOnTap,
    this.rightButtonOnTap,
    this.customButtonCount = 2,
  });

  final String title;
  final String bodyText;
  final Image? image;
  final Color titleColor;
  final String leftButtonText;
  final String rightButtonText;
  final Function? leftButtonOnTap;
  final Function? rightButtonOnTap;
  final int customButtonCount;

  @override
  Widget build(BuildContext context) {
    late List<String> buttonTextList;
    late List<Function?> buttonOnTapList;
    if (customButtonCount != 0) {
      buttonTextList = [
        leftButtonText,
        rightButtonText,
      ];
      buttonOnTapList = [
        leftButtonOnTap,
        rightButtonOnTap,
      ];
    }
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
                text: bodyText,
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom:
                    customButtonCount == 0 || customButtonCount > 2 ? 0 : 10,
              ),
              height:
                  customButtonCount == 0 || customButtonCount > 2 ? null : 60,
              child: customButtonCount == 0 || customButtonCount > 2
                  ? null
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i = 0; i < customButtonCount; i++) ...{
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: CustomButton(
                                isFilledColor: i == 1 ? true : false,
                                text: buttonTextList[i],
                                onTap: () {
                                  Navigator.pop(context);
                                  if (buttonOnTapList[i] != null) {
                                    buttonOnTapList[i]!.call();
                                  }
                                },
                              ),
                            ),
                          ),
                        }
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
