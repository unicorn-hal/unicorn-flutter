import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class AiAnnounceBanner extends StatelessWidget {
  const AiAnnounceBanner({
    super.key,
    required this.title,
    required this.description,
    required this.bannerColor,
    required this.imageBackgroundColor,
    required this.onTap,
  });

  final String title;
  final String description;
  final Color bannerColor;
  final Color imageBackgroundColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 88,
          width: size.width,
          decoration: BoxDecoration(
            color: bannerColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: imageBackgroundColor.withOpacity(0.5),
                    image: DecorationImage(
                      image: Assets.images.icons.aiIcon.provider(),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 30,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: title,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    height: 44,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomText(
                        text: description,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
