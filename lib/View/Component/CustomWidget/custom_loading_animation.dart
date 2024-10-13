import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class CustomLoadingAnimation extends StatelessWidget {
  const CustomLoadingAnimation({
    super.key,
    required this.text,
    this.iconSize = 30,
    this.fontSize = 20,
    required this.iconColor,
    required this.textColor,
  });

  final String text;
  final double iconSize;
  final double fontSize;
  final Color iconColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.inkDrop(
          color: iconColor,
          size: iconSize,
        ),
        const SizedBox(
          width: 10,
        ),
        CustomText(
          text: text,
          fontSize: fontSize,
          color: textColor,
        ),
      ],
    );
  }
}
