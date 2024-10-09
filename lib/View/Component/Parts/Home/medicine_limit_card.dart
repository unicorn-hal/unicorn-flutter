import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MedicineLimitCard extends StatelessWidget {
  const MedicineLimitCard({
    super.key,
    required this.medicineName,
    required this.remainingDays,
    required this.remainingCount,
    required this.progressColor,
    required this.currentNum,
    required this.totalNum,
  });

  // todo: medicineクラスができたら引数を変更する

  final String medicineName;
  final int remainingDays;
  final int remainingCount;
  final Color progressColor;
  final int currentNum;
  final int totalNum;

  // currentNumとtotalNumから残り%を計算
  double getProgressRate() {
    return (currentNum / totalNum * 100);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: size.width * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: ColorName.shadowGray,
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: size.width * 0.3,
              height: size.width * 0.3,
              child: CircularPercentIndicator(
                radius: size.width * 0.14,
                lineWidth: 20.0,
                percent: getProgressRate() / 100,
                center: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      text: getProgressRate().toInt().toString(),
                      fontSize: 18,
                    ),
                    const CustomText(
                      text: '%',
                      fontSize: 14,
                    ),
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: progressColor,
              ),
            ),
            SizedBox(
              width: size.width * 0.4,
              height: size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: 'おくすり名',
                    fontSize: 12,
                    color: ColorName.textGray,
                  ),
                  CustomText(text: medicineName),
                  const CustomText(
                    text: '残り日数/個数',
                    fontSize: 12,
                    color: ColorName.textGray,
                  ),
                  CustomText(text: '$remainingDays日分/残り$remainingCount個'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
