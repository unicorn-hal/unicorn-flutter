import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Model/custom_picker.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class CustomDrumRoll extends StatefulWidget {
  const CustomDrumRoll({
    super.key,
    required this.customPicker,
    this.maxTime,
    this.reservation,
    this.minute,
  });

  final bool customPicker;
  final DateTime? maxTime;
  final DateTime? reservation;
  final int? minute;

  /// minuteに入れるのは5,10,15,30のみにしてください

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
      DateTime now = DateTime.now();
      scheduledTime = widget.minute != null
          ? DateTime(now.year, now.month, now.day, now.hour, 0)
          : now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.customPicker
            ? DatePicker.showPicker(
                context,
                locale: LocaleType.jp,
                onChanged: (date) {},
                onConfirm: (date) {
                  // todo: Controllerにdateを渡す処理追記予定
                  scheduledTime = date;
                  setState(() {});
                },
                pickerModel: CustomPicker(
                  currentTime: DateTime.now(),
                  locale: LocaleType.jp,
                  minute: widget.minute ?? 1,
                ),
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
          color: ColorName.drumRollButtonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomText(
          text: widget.customPicker
              ? DateFormat('HH:mm').format(scheduledTime)
              : DateFormat('yyyy MM/dd').format(scheduledTime),
          color: Colors.blue,
        ),
      ),
    );
  }
}
