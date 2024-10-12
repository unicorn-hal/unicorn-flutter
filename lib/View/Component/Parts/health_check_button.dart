import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class HealthCheckButton extends StatelessWidget {
  const HealthCheckButton({
    super.key,
    required this.onTap,
    this.aiCheck = false,
  });
  final bool aiCheck;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        width: size.width * 0.9,
        height: 70,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.8],
            colors: [
              ColorName.healthCheckButtonStart,
              ColorName.healthCheckButtonEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    aiCheck ? Icons.mic : Icons.monitor_heart,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                CustomText(
                  text: '今日の検診を開始する',
                  color: Colors.white,
                  fontSize: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
