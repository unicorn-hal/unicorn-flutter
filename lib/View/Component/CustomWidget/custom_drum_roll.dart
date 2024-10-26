import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Model/custom_picker.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

enum DrumRollType { date, time }

// DrumRollType.dateの場合は日付を、DrumRollType.timeの場合は時間を選択できる
// maxTime、reservation、minuteはDrumRollType.timeの場合のみ引数で要求する
class CustomDrumRoll extends StatefulWidget {
  const CustomDrumRoll({
    super.key,
    required this.drumRollType,
    this.maxDate,
    this.reservation,
    this.splitMinute,
  });

  final DrumRollType drumRollType;
  final DateTime? maxDate;
  final DateTime? reservation;
  final int? splitMinute;

  /// minuteに入れるのは5,10,15,30のみにしてください

  @override
  State<CustomDrumRoll> createState() => _CustomDrumRollState();
}

class _CustomDrumRollState extends State<CustomDrumRoll> {
  DateTime? reservation;

  CustomPicker get customPicker {
    switch (widget.drumRollType) {
      case DrumRollType.date:
        return CustomPicker(
          drumRollType: widget.drumRollType,
          maxDate: widget.maxDate,
          currentTime: reservation ?? DateTime.now(),
        );
      case DrumRollType.time:
        return CustomPicker(
          drumRollType: widget.drumRollType,
          splitMinute: widget.splitMinute ?? 1,
          currentTime: reservation ?? DateTime.now(),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      reservation = widget.reservation!;
    } else {
      DateTime now = DateTime.now();
      reservation = widget.splitMinute != null
          ? DateTime(now.year, now.month, now.day, now.hour, 0)
          : now;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DatePicker.showPicker(
          context,
          locale: LocaleType.jp,
          onChanged: (date) {},
          onConfirm: (date) {
            reservation = date;
            setState(() {});
          },
          pickerModel: customPicker,
        );

        // widget.customPicker
        //     ? DatePicker.showPicker(
        //         context,
        //         locale: LocaleType.jp,
        //         onChanged: (date) {},
        //         onConfirm: (date) {
        //           // todo: Controllerにdateを渡す処理追記予定
        //           scheduledTime = date;
        //           setState(() {});
        //         },
        //         pickerModel: CustomPicker(
        //           currentTime: DateTime.now(),
        //           locale: LocaleType.jp,
        //           minute: widget.minute ?? 1,
        //         ),
        //       )
        //     : DatePicker.showDatePicker(
        //         context,
        //         showTitleActions: true,
        //         minTime: DateTime(1900, 1, 1),
        //         maxTime: widget.maxTime ?? DateTime.now(),
        //         onChanged: (date) {},
        //         onConfirm: (date) {
        //           // todo: Controllerにdateを渡す処理追記予定
        //           scheduledTime = date;
        //           setState(() {});
        //         },
        //         currentTime: DateTime.now(),
        //         locale: LocaleType.jp,
        //       );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorName.drumRollButtonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomText(
          // text: widget.customPicker
          //     ? DateFormat('HH:mm').format(scheduledTime)
          //     : DateFormat('yyyy MM/dd').format(scheduledTime),
          text: widget.drumRollType == DrumRollType.time
              ? DateFormat('HH:mm').format(reservation ?? DateTime.now())
              : DateFormat('yyyy MM/dd').format(reservation ?? DateTime.now()),
          color: Colors.blue,
        ),
      ),
    );
  }
}
