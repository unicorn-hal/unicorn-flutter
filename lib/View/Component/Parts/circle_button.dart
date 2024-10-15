import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.buttonSize,
    required this.buttonColor,
    required this.onTap,
    required this.icon,
  });

  final double buttonSize;
  final Color buttonColor;
  final Icon icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle
        ),
        width: buttonSize,
        height: buttonSize,
        child: FractionallySizedBox(
          widthFactor: 0.6,
          heightFactor: 0.6,
          child: FittedBox(
            fit: BoxFit.cover,
            child: icon,
          ),
        ),
      ),
    );
  }
}