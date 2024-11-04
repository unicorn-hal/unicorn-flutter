import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_drum_roll.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class VoiceCallReserveView extends StatefulWidget {
  const VoiceCallReserveView({super.key});

  @override
  State<VoiceCallReserveView> createState() => _VoiceCallReserveViewState();
}

class _VoiceCallReserveViewState extends State<VoiceCallReserveView> {
  // todo: controllerへ移植する
  final String doctorName = '長谷川';

  final String chatSupportHours = '平日9:00~12:00';

  final String callSupportHours = '平日14:00~22:00';

  DateTime selectedDate = DateTime.now();
  DateTime selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      isScrollable: true,
      appBar: CustomAppBar(
        backgroundColor: ColorName.mainColor,
        foregroundColor: Colors.white,
        title: '通話予約',
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: size.width * 0.9,
                height: 150,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: '"$doctorName先生"',
                        fontSize: 30,
                      ),
                      const CustomText(
                        text: 'との通話予約をする',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: size.width * 0.9,
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorName.shadowGray,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: CustomText(
                      text: '対応可能時間',
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: CustomText(text: 'チャット: $chatSupportHours'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: CustomText(
                      text: '通話: $callSupportHours',
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: SpacerAndDivider(),
            ),
            SizedBox(
              height: 90,
              width: size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 150,
                    height: 90,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: '日付',
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 60,
                          child: FittedBox(
                            child: CustomDrumRoll(
                              drumRollType: DrumRollType.date,
                              onConfirm: (DateTime date) {
                                selectedDate = date;
                                setState(() {});
                              },
                              minDate: DateTime.now(),
                              maxDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 90,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: '時間',
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 60,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            child: CustomDrumRoll(
                              drumRollType: DrumRollType.time,
                              onConfirm: (DateTime time) {
                                selectedTime = time;
                                setState(() {});
                              },
                              splitMinute: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * 0.9,
              height: 200,
              child: GestureDetector(
                onTap: () {
                  // todo: 予約処理 > controllerへ移植する
                  DateTime reserveDateTime = DateTime(
                    selectedDate.year,
                    selectedDate.month,
                    selectedDate.day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                  Log.echo('reserveDateTime: $reserveDateTime');
                },
                child: Center(
                  child: Container(
                    width: size.width * 0.9,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorName.mainColor,
                    ),
                    child: const Center(
                      child: CustomText(
                        text: 'この日付で予約する',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
