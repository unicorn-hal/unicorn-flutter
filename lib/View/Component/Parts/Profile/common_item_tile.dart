import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class CommonItemTile extends StatelessWidget {
  const CommonItemTile({
    super.key,
    required this.title,
    required this.action,
    this.onTap,
    this.verticalPadding = 0,
    this.tileHeight = 50,
    this.fontSize = 14,
  });
  final String title;
  final Widget action;
  final Function? onTap;
  final double verticalPadding;
  final double tileHeight;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: Container(
        width: deviceWidth * 0.9,
        height: tileHeight,
        decoration: const BoxDecoration(
          border: BorderDirectional(
            bottom: BorderSide(
              width: 1,
              color: Colors.grey,
              // todo: 他のpartsと色を合わせる可能性あり
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: CustomText(
                  text: title,
                  fontSize: fontSize,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                  child: GestureDetector(
                onTap: () => onTap?.call(),
                child: action,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
