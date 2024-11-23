import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/VoiceCall/voice_call_reserve_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_indicator.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../../../../Model/Entity/Call/call.dart';
import '../../../../../Model/Entity/Doctor/doctor.dart';

class VoiceCallReserveView extends StatefulWidget {
  const VoiceCallReserveView({
    super.key,
    required this.doctor,
  });

  final Doctor doctor;

  @override
  State<VoiceCallReserveView> createState() => _VoiceCallReserveViewState();
}

class _VoiceCallReserveViewState extends State<VoiceCallReserveView> {
  late VoiceCallReserveController controller;

  @override
  void initState() {
    super.initState();
    controller = VoiceCallReserveController(context, widget.doctor);
  }

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
            // 他のウィジェット部分は省略
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
                        text:
                            '"${widget.doctor.lastName + widget.doctor.firstName}先生"',
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
                    child: CustomText(
                        text: 'チャット: ${widget.doctor.chatSupportHours}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: CustomText(
                      text: '通話: ${widget.doctor.callSupportHours}',
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
            FutureBuilder(
                future: controller.getDoctorReservation(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      width: size.width * 0.9,
                      height: 400,
                      child: const Center(
                        child: CustomIndicator(),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CustomText(
                        text: 'エラーが発生しました',
                      ),
                    );
                  }

                  final Map<DateTime, List<Call>>? events = snapshot.data;
                  return StatefulBuilder(builder: (context, setState) {
                    return SizedBox(
                      width: size.width * 0.9,
                      child: Column(
                        children: [
                          TableCalendar(
                            locale: 'ja_JP',
                            firstDay: DateTime.now(),
                            lastDay:
                                DateTime.now().add(const Duration(days: 365)),
                            focusedDay: controller.calendarDate,
                            currentDay: controller.calendarDate,
                            calendarFormat: CalendarFormat.month,
                            headerStyle: const HeaderStyle(
                              headerMargin: EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              titleTextStyle: TextStyle(
                                color: ColorName.textBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Noto_Sans_JP',
                              ),
                              formatButtonVisible: false,
                              leftChevronVisible: false,
                              rightChevronIcon: Icon(
                                Icons.chevron_right,
                                color: ColorName.mainColor,
                              ),
                            ),
                            availableGestures:
                                AvailableGestures.horizontalSwipe,
                            onDaySelected:
                                (DateTime selectedDay, DateTime focusedDay) {
                              controller.setReserveDate();
                              controller.changeCalendarDate(selectedDay);
                              setState(() {});
                            },
                            selectedDayPredicate: (day) {
                              return isSameDay(controller.calendarDate, day);
                            },
                            eventLoader: (day) {
                              final DateTime targetDate = DateTime(
                                day.year,
                                day.month,
                                day.day,
                              );
                              return events![targetDate] ?? [];
                            },
                            calendarStyle: const CalendarStyle(
                              tablePadding: EdgeInsets.all(2.0),
                              todayDecoration: BoxDecoration(
                                color: ColorName.mainColor,
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: ColorName.mainColor,
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                              selectedTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            calendarBuilders: CalendarBuilders(
                              // 曜日のヘッダーをカスタマイズ
                              dowBuilder: (context, day) {
                                TextStyle textStyle = const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold);

                                if (day.weekday == DateTime.saturday) {
                                  textStyle = const TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold);
                                } else if (day.weekday == DateTime.sunday) {
                                  textStyle = const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold);
                                }

                                return Center(
                                  child: Text(
                                    DateFormat.E('ja_JP')
                                        .format(day), // 日本語の曜日名
                                    style: textStyle,
                                  ),
                                );
                              },
                              // 日付セルをカスタマイズ
                              defaultBuilder: (context, day, focusedDay) {
                                TextStyle textStyle =
                                    const TextStyle(color: Colors.black);

                                if (day.weekday == DateTime.saturday) {
                                  textStyle =
                                      const TextStyle(color: Colors.blue);
                                } else if (day.weekday == DateTime.sunday) {
                                  textStyle =
                                      const TextStyle(color: Colors.red);
                                }

                                return Center(
                                  child: Text(
                                    '${day.day}',
                                    style: textStyle,
                                  ),
                                );
                              },
                              selectedBuilder: (context, day, focusedDay) {
                                TextStyle textStyle =
                                    const TextStyle(color: Colors.white);

                                return Container(
                                  decoration: const BoxDecoration(
                                    color: ColorName.mainColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: textStyle,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: size.width * 0.9,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 3,
                                crossAxisSpacing: 3,
                                childAspectRatio: 4,
                              ),
                              itemCount: controller.timeSlots.length,
                              itemBuilder: (context, index) {
                                bool isAvailableTime =
                                    controller.isAvailableTimeSlot(
                                        events![controller.normalizeDate(
                                            controller.calendarDate)],
                                        controller.timeSlots[index]);

                                return GestureDetector(
                                  onTap: () {
                                    if (!isAvailableTime) {
                                      Fluttertoast.showToast(
                                        msg: Strings
                                            .VOICE_CALL_DISABLE_ERROR_TEXT,
                                      );
                                      return;
                                    }
                                    // 選択した時間を予約日時に設定
                                    controller.setReserveDate(index: index);
                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: controller.selectedTimeSlotIndex ==
                                              index
                                          ? ColorName.mainColor
                                          : isAvailableTime
                                              ? Colors.white
                                              : ColorName.shadowGray,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: ColorName.shadowGray,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          isAvailableTime
                                              ? Icon(
                                                  Icons.circle_outlined,
                                                  color: controller
                                                              .selectedTimeSlotIndex ==
                                                          index
                                                      ? Colors.white
                                                      : Colors.green,
                                                  size: 18,
                                                )
                                              : const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                          CustomText(
                                            text: controller.timeSlots[index],
                                            color: controller
                                                        .selectedTimeSlotIndex ==
                                                    index
                                                ? Colors.white
                                                : null,
                                            fontSize: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  });
                }),

            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width * 0.9,
              height: 200,
              child: GestureDetector(
                onTap: () {
                  controller.reserveCall();
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
