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
    required this.buttonOnTap,
    required this.color,
  });

  final Medicine medicine;
  final VoidCallback buttonOnTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final String medicineName = medicine.medicineName;
    final int remainingDays = (medicine.quantity / medicine.dosage).ceil();
    final int remainingQuantity = medicine.quantity;
    final int totalNum = medicine.count;

    // totalNumとremainingQuantityから残り%を計算
    double getProgressRate() {
      return (remainingQuantity / totalNum * 100);
    }

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
                progressColor: color,
              ),
            ),
            SizedBox(
              width: size.width * 0.4,
              height: size.width * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 4),
                      CustomText(
                        text: medicineName,
                        fontSize: 24,
                        textOverflow: TextOverflow.ellipsis,
                      ),
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
                  Container(
                    padding: const EdgeInsets.only(bottom: 4),
                    height: 32,
                    width: size.width * 0.35,
                    child: CustomButton(
                      text: '飲む',
                      onTap: buttonOnTap,
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
