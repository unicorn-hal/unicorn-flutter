import 'package:flutter/material.dart';

class SpacerAndDivider extends StatelessWidget {
  const SpacerAndDivider({
    super.key,
    this.topHeight = 20,
    this.bottomHeight = 20,
  });

  final double topHeight;
  final double bottomHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: topHeight,
        ),
        const Divider(),
        SizedBox(
          height: bottomHeight,
        ),
      ],
    );
  }
}
