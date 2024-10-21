import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({
    super.key,
    this.strokeWidth,
    this.value,
    this.color = Colors.grey,
    this.backgroundColor,
    this.strokeCap,
  });

  final double? strokeWidth;
  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final StrokeCap? strokeCap;

  /// アプリ全体で使うカスタムインジケーターです

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      strokeWidth: strokeWidth ?? 2.0,
      value: value,
      color: color,
      backgroundColor: backgroundColor,
      strokeCap: strokeCap,
    );
  }
}
