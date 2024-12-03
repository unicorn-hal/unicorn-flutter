import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MedicineLimitCard extends StatelessWidget {
  const MedicineLimitCard({
    super.key,
    required this.medicine,
    required this.submitOnTap,
    required this.editOnTap,
    required this.color,
  });

  final Medicine medicine;
  final VoidCallback submitOnTap;
  final VoidCallback editOnTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final String medicineName = medicine.medicineName;
    final int remainingDays = (medicine.quantity / medicine.dosage).ceil();
    final int remainingQuantity = medicine.quantity;
    final int totalNum = medicine.count;

    final List<Color> progressColor = [
      Colors.green,
      Colors.yellow,
      Colors.red,
    ];

    // totalNumとremainingQuantityから残り%を計算
    double getProgressRate() {
      return (remainingQuantity / totalNum * 100);
    }

    // 残り%に応じて色を決定
    Color getProgressColor(double progressRate) {
      if (progressRate > 66) {
        return progressColor[0];
      } else if (progressRate > 33) {
        return progressColor[1];
      } else {
        return progressColor[2];
      }
    }

    final double progressRate = getProgressRate();

    return Container(
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: editOnTap,
              ),
            ),
            SizedBox(
              width: size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularPercentIndicator(
                    radius: size.width * 0.18,
                    lineWidth: 22.0,
                    percent: progressRate / 100,
                    center: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          text: progressRate.toInt().toString(),
                          fontSize: 22,
                        ),
                        const SizedBox(width: 2),
                        const CustomText(
                          text: '%',
                          fontSize: 14,
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: getProgressColor(progressRate),
                  ),
                  CustomText(
                    text: medicineName,
                    fontSize: 26,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 4),
                      const CustomText(
                        text: '服用回数 / 錠数',
                        fontSize: 12,
                        color: ColorName.textGray,
                      ),
                      CustomText(
                          text: '残り $remainingDays回 / $remainingQuantity錠'),
                    ],
                  ),
                  SizedBox(
                    width: size.width * 0.6,
                    height: 42,
                    child: CustomButton(
                      text: '飲む',
                      onTap: submitOnTap,
                      isFilledColor: true,
                      primaryColor: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
