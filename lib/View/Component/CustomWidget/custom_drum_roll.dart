import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class CustomDrumRoll extends StatefulWidget {
  const CustomDrumRoll({
    super.key,
    required this.showTime,
    this.maxTime,
    this.reservation,
  });

  final bool showTime;
  final DateTime? maxTime;
  final DateTime? reservation;

  @override
  State<CustomDrumRoll> createState() => _CustomDrumRollState();
}

class _CustomDrumRollState extends State<CustomDrumRoll> {
  late DateTime scheduledTime;
  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      scheduledTime = widget.reservation!;
    } else {
      scheduledTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.showTime
            ? DatePicker.showTime12hPicker(
                context,
                showTitleActions: true,
                onChanged: (date) {},
                onConfirm: (date) {
                  // todo: Controllerにdateを渡す処理追記予定
                  scheduledTime = date;
                  setState(() {});
                },
                currentTime: DateTime.now(),
                locale: LocaleType.jp,
              )
            : DatePicker.showDatePicker(
                context,
                showTitleActions: true,
                minTime: DateTime(1900, 1, 1),
                maxTime: widget.maxTime ?? DateTime.now(),
                onChanged: (date) {},
                onConfirm: (date) {
                  // todo: Controllerにdateを渡す処理追記予定
                  scheduledTime = date;
                  setState(() {});
                },
                currentTime: DateTime.now(),
                locale: LocaleType.jp,
              );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 212, 212, 212),
          // todo: 専用色決まったら変更
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomText(
          text: widget.showTime
              ? DateFormat('hh:mm a').format(scheduledTime)
              : DateFormat('yyyy MM/dd').format(scheduledTime),
          color: Colors.blue,
          // todo: ここの色も変えるかも
        ),
      ),
    );
  }
}
