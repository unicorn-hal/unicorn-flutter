import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CustomModal extends StatefulWidget {
  const CustomModal({
    super.key,
    required this.title,
    required this.content,
    this.topMargin = 64,
    this.leftButtonText = '戻る',
    this.rightButtonText = '決定',
    this.leftButtonOnTap,
    this.rightButtonOnTap,
    this.leftButtonColor = ColorName.subColor,
    this.rightButtonColor = ColorName.subColor,
    this.backgroundColor = Colors.white,
    this.isRightButton = true,
  });
  final String title;
  final Widget content;
  final double topMargin;
  final String leftButtonText;
  final String rightButtonText;
  final Function? leftButtonOnTap;
  final Function? rightButtonOnTap;
  final Color leftButtonColor;
  final Color rightButtonColor;
  final Color backgroundColor;
  final bool isRightButton;

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: deviceWidth,
      margin: EdgeInsets.only(top: widget.topMargin),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      if (widget.leftButtonOnTap != null) {
                        widget.leftButtonOnTap!.call();
                      }
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: CustomText(
                        text: widget.leftButtonText,
                        color: widget.leftButtonColor,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.isRightButton,
                    child: TextButton(
                      onPressed: () {
                        if (widget.rightButtonOnTap != null) {
                          widget.rightButtonOnTap!.call();
                        }
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 10,
                        ),
                        child: CustomText(
                          text: widget.rightButtonText,
                          color: widget.rightButtonColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(
                  top: 12,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: CustomText(
                    text: widget.title,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          widget.content,
        ],
      ),
    );
  }
}
