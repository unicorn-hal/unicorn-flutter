import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class DepartmentBadge extends StatelessWidget {
  const DepartmentBadge({
    super.key,
    required this.name,
    this.height = 40,
  });

  final String name;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorName.shadowGray,
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: const BoxConstraints(
        minWidth: 100,
      ),
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 8,
        ),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: CustomText(
            text: '#$name',
          ),
        ),
      ),
    );
  }
}
