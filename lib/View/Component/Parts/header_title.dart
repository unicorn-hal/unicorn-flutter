import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    super.key,
    required this.title,
    this.fontSize = 20,
    this.padding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
  });

  final String title;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
        ),
        child: CustomText(
          text: title,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
