import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
// todo: Comment/Parts/ProfileからComment/Partsに引っ越し

class CommonItemTile extends StatelessWidget {
  const CommonItemTile({
    super.key,
    required this.title,
    this.action,
    this.onTap,
    this.verticalPadding = 0,
    this.tileHeight = 50,
    this.fontSize = 14,
    this.boxDecoration = const BoxDecoration(
      color: Colors.white,
      border: BorderDirectional(
        bottom: BorderSide(
          width: 1,
          color: Colors.grey,
        ),
      ),
    ),
  });
  final String title;
  final Widget? action;
  final Function? onTap;
  // todo: viewが全部出来たタイミングでvoidCallbackに変える
  final double verticalPadding;
  final double tileHeight;
  final double fontSize;
  final Decoration boxDecoration;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding),
      child: GestureDetector(
        onTap: () => onTap?.call(),
        child: Container(
          width: deviceWidth * 0.9,
          height: tileHeight,
          decoration: boxDecoration,
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
              action != null
                  ? Expanded(
                      flex: 1,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => onTap?.call(),
                          child: action,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
