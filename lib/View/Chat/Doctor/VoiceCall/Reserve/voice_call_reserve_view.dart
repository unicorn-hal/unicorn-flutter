import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/VoiceCall/voice_call_reserve_controller.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_drum_roll.dart';
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
            Stack(
              children: [
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
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () async {
                      final Map<DateTime, List<Call>>? events =
                          await controller.getDoctorReservation();

                      if (events == null) {
                        return;
                      }

                      showDialog(
                          context: context,
                          builder: (_) {
                            return Column(
                              children: [
                                Dialog(
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  child: StatefulBuilder(
                                      builder: (context, setState) {
                                    return TableCalendar(
                                      currentDay: controller.calendarDate,
                                      focusedDay: DateTime.now(),
                                      firstDay: DateTime.now().add(
                                        const Duration(days: -365),
                                      ),
                                      lastDay: DateTime.now()
                                          .add(const Duration(days: 365)),
                                      calendarFormat: CalendarFormat.month,
                                      headerStyle: const HeaderStyle(
                                        formatButtonVisible: false,
                                        leftChevronIcon: Icon(
                                          Icons.chevron_left,
                                          color: ColorName.mainColor,
                                        ),
                                        rightChevronIcon: Icon(
                                          Icons.chevron_right,
                                          color: ColorName.mainColor,
                                        ),
                                      ),
                                      onDaySelected: (DateTime selectedDay,
                                          DateTime focusedDay) {
                                        controller
                                            .changeCalendarDate(selectedDay);
                                        setState(() {});
                                      },
                                      selectedDayPredicate: (day) {
                                        return isSameDay(
                                            controller.calendarDate, day);
                                      },
                                      eventLoader: (day) {
                                        final DateTime targetDate = DateTime(
                                          day.year,
                                          day.month,
                                          day.day,
                                        );
                                        return events[targetDate] ?? [];
                                      },
                                    );
                                  }),
                                ),
                                Expanded(
                                    child: ListView.builder(
                                        itemCount: events[controller
                                                    .normalizeDate(controller
                                                        .calendarDate)]
                                                ?.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            width: 100,
                                            height: 50,
                                            color: Colors.red,
                                          );
                                        }))
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorName.mainColor),
                      child: const Icon(Icons.calendar_month,
                          color: Colors.white, size: 30),
                    ),
                  ),
                )
              ],
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
                                controller.changeDate(date);
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
                                controller.changeTime(time);
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
