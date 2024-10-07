import 'package:flutter/material.dart';

import '../../../gen/colors.gen.dart';

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.text,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.textOverflow,
      this.underLines = false});

  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextOverflow? textOverflow;
  final bool underLines;

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: color ?? ColorName.textBlack,
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.bold,
      fontFamily: 'Noto_Sans_JP',
      decoration: underLines ? TextDecoration.underline : null,
      decorationColor: underLines ? Colors.blue : null,
    );
    return Text(
      text,
      style: textStyle,
      overflow: textOverflow,
    );
  }
}
