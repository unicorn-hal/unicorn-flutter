import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({
    super.key,
    this.strokeWidth,
    this.color,
    this.value,
    this.backgroundColor,
  });

  final double? strokeWidth;
  final double? value;
  final Color? color;
  final Color? backgroundColor;

  /// アプリ全体で使うカスタムインジケーターです
  ///

  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator(
      strokeWidth: 10,
      color: Colors.grey,
    );
  }
}
