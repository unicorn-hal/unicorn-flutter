import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class RegisterContentTile extends StatelessWidget {
  const RegisterContentTile({
    super.key,
    required this.tileText,
    required this.onTap,
  });
  final String tileText;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () => onTap.call(),
        child: DottedBorder(
          dashPattern: const [15, 10],
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            width: deviceWidth * 0.9,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.grey,
                  size: 22,
                ),
                CustomText(
                  text: tileText,
                  color: ColorName.textGray,
                  fontSize: 14,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
