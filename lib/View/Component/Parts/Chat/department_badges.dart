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
    final Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: ColorName.shadowGray,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(
        minWidth: 100,
      ),
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
