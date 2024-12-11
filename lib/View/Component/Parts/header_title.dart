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
    this.useBorder = true,
  });

  final String title;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final bool useBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: useBorder
              ? const Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                )
              : null,
        ),
        child: CustomText(
          text: title,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
