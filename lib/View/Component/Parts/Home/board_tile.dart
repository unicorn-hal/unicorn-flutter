import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class BoardTile extends StatelessWidget {
  const BoardTile({
    super.key,
    required this.title,
    required this.content,
    this.onTap,
  });

  final String title;
  final String content;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        width: size.width * 0.9,
        constraints: const BoxConstraints(minHeight: 40),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: size.width * 0.8,
                child: CustomText(text: title),
              ),
              SizedBox(
                width: size.width * 0.8,
                child: CustomText(
                  text: content,
                  fontSize: 12,
                  color: ColorName.textGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
