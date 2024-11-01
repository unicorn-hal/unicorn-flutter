import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.isFilledColor = false,
    this.primaryColor = ColorName.mainColor,
    required this.text,
    required this.onTap,
  });

  final Color primaryColor;
  final bool isFilledColor;
  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
        side: BorderSide(
          color: primaryColor,
        ),
        elevation: 0,
        fixedSize: const Size.fromHeight(40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),

        ///isFilledColorがtrueの場合はprimaryColorを使う,falseの場合はdefaultの白
        backgroundColor: isFilledColor ? primaryColor : Colors.white,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: CustomText(
          text: text,
          fontSize: 14,
          color: isFilledColor ? Colors.white : primaryColor,
        ),
      ),
    );
  }
}
