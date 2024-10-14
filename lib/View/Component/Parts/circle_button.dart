import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.isbuttonFilledColor = false,
    this.buttonFilledColor = Colors.white,
    this.imageSize = 100,
    required this.onTap,
    required this.icon,
  });

  // isbuttonFilledColorは不要であれば削除
  final bool isbuttonFilledColor;
  // isbuttonFilledColorをtrue -> buttonFilledColorに色指定して背景色がその指定した色に変化
  // isbuttonFilledColorをfalse -> デフォの灰色の背景色
  final Color buttonFilledColor;
  final double imageSize;
  final Function onTap;
  final Image icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        fixedSize: Size(imageSize, imageSize),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(imageSize / 2)
        ),
        backgroundColor: isbuttonFilledColor ? buttonFilledColor : Colors.grey,
      ),
      child: Container(
        width: imageSize / 2,
        height: imageSize / 2,
        color: Colors.white.withOpacity(1.0),
        child: FittedBox(
          fit: BoxFit.cover,
          child: icon,
        ),
      ),
    );
  }
}