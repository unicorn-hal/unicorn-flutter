import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ProfileDetailCell extends StatelessWidget {
  const ProfileDetailCell({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final Icon icon;
  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorName.shadowGray,
              spreadRadius: 1.0,
              blurRadius: 5,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: icon,
                ),
              ),
              Expanded(
                flex: 1,
                child: CustomText(
                  text: title,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
