import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CallReservationTile extends StatelessWidget {
  const CallReservationTile({
    super.key,
    this.doctorIconUrl,
    required this.doctorName,
    required this.callDate,
    required this.callTime,
    required this.chatButtonOnTap,
    required this.deleteButtonOnTap,
  });
  final String doctorName;
  final String? doctorIconUrl;
  final String callDate;
  final String callTime;
  final Function chatButtonOnTap;
  final Function deleteButtonOnTap;

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      width: deviceWidth * 0.9,
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
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              height: deviceWidth * 0.3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: deviceWidth * 0.3,
                    width: deviceWidth * 0.3,
                    child: Align(
                      alignment: Alignment.center,
                      child: UserImageCircle(
                        imageUrl: doctorIconUrl,
                        imageSize: deviceWidth * 0.25,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: deviceWidth * 0.25,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: '$doctorName先生',
                            fontSize: 18,
                          ),
                          CustomText(
                            text: callDate,
                          ),
                          CustomText(
                            text: callTime,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: CustomButton(
                      text: 'チャットへ',
                      onTap: () => chatButtonOnTap.call(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: CustomButton(
                      isFilledColor: true,
                      text: '予約削除',
                      onTap: () => deleteButtonOnTap.call(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
