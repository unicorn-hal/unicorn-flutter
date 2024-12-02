import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class ReceiveCallCell extends StatelessWidget {
  const ReceiveCallCell({
    super.key,
    required this.doctorName,
    required this.hospitalName,
    required this.reservationDateTimes,
    required this.onTap,
  });
  final String doctorName;
  final String hospitalName;
  final String reservationDateTimes;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap.call(),
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.call, color: Colors.green),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 5,
                    left: 10,
                    right: 10,
                  ),
                  child: CustomText(
                    text: '通話の準備ができました',
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: '$doctorName先生',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    const SizedBox(width: 5),
                    CustomText(
                      text: '($hospitalName)',
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ],
                ),
                CustomText(
                  text: reservationDateTimes,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
