import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({
    super.key,
    required this.title,
    this.padding = const EdgeInsets.symmetric(
      vertical: 8.0,
      horizontal: 16.0,
    ),
    this.fontSize = 16,
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
          color: ColorName.subColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: useBorder
              ? const Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.circle,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(
                width: 5,
              ),
              CustomText(
                text: title,
                fontSize: fontSize,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
