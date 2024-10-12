import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({
    super.key,
    this.title = '',
    this.backgroundColor = Colors.white,
    this.foregroundColor = ColorName.textBlack,
    this.appBarHight = kToolbarHeight,
    this.leadingImage,
    this.actions,
  });
  final String? title;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final ImageProvider? leadingImage;
  double? appBarHight;
  List<IconButton>? actions;

  @override
  Size get preferredSize => Size.fromHeight(appBarHight!); // ここでAppBarの高さを指定

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          leadingImage != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    height: appBarHight!,
                    width: appBarHight!,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: leadingImage!,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          CustomText(
            text: title!,
            color: foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
      backgroundColor: backgroundColor,

      // スクロール時に色が乗算されるのを防ぐ
      surfaceTintColor: backgroundColor,
      // 設置しても3つくらいまでが限度かなーー？
      actions: actions,
      elevation: 10,
      shadowColor: Colors.black.withOpacity(0.1),
    );
  }
}
