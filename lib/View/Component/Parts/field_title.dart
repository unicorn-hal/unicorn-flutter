import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class FieldTitle extends StatelessWidget {
  const FieldTitle({
    super.key,
    required this.title,
    this.fontSize = 15,
    this.padding = EdgeInsets.zero,
    this.icon = Icons.edit,
    this.iconColor = ColorName.mainColor,
  });

  final String title;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CustomText(
                text: title,
                fontSize: fontSize,
              ),
            ),
            Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
