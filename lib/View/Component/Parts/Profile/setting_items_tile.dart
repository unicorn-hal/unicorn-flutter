import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class SettingItemsTile extends StatelessWidget {
  const SettingItemsTile({
    super.key,
    required this.title,
    required this.action,
    required this.onTap,
  });
  final String title;
  final Widget action;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: deviceWidth * 0.9,
      height: 50,
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
            child: CustomText(
              text: title,
              fontSize: 14,
              // todo: fontSize調整するか可変にする可能性あり
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
                child: GestureDetector(
              onTap: () {
                onTap();
              },
              child: action,
            )),
          ),
        ],
      ),
    );
  }
}
