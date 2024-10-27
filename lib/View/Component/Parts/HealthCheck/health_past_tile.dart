import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class HealthPastTile extends StatelessWidget {
  const HealthPastTile(
      {super.key,
      required this.timeDate,
      required this.bodyTemperature,
      required this.bloodPressure});

  final DateTime timeDate;
  final double bodyTemperature;
  final String bloodPressure;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        width: size.width * 0.9,
        height: 60,
        child: Column(
          children: [
            SizedBox(
              width: size.width * 0.9,
              height: 30,
              child: CustomText(
                text: DateFormat('yyyy年MM月dd日').format(timeDate),
                fontSize: 18,
              ),
            ),
            SizedBox(
              width: size.width * 0.9,
              height: 28,
              child: CustomText(
                text: '体温 : $bodyTemperature℃  血圧 : ${bloodPressure}mmHg',
                color: ColorName.textGray,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
