import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Model/custom_picker.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

enum DrumRollType { date, time }

class CustomDrumRoll extends StatefulWidget {
  /// [drumRollType] : 日付または時間を選択する
  /// [initValue] : 初期値
  /// [maxDate] : [日付のみ] 選択可能な最大日時
  /// [splitMinute] : [時間のみ] 指定分で分割する (5,10,15,30)
  const CustomDrumRoll({
    super.key,
    required this.drumRollType,
    required this.onConfirm,
    this.onChanged,
    this.initValue,
    this.maxDate,
    this.minDate,
    this.splitMinute,
  });

  final DrumRollType drumRollType;
  final Function(DateTime) onConfirm;
  final Function(DateTime)? onChanged;
  final DateTime? initValue;
  final DateTime? maxDate;
  final DateTime? minDate;
  final int? splitMinute;

  @override
  State<CustomDrumRoll> createState() => _CustomDrumRollState();
}

class _CustomDrumRollState extends State<CustomDrumRoll> {
  late DateTime _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initValue ?? DateTime.now();
    if (widget.splitMinute != null) {
      int minute = ((_currentValue.minute + widget.splitMinute! - 1) ~/
              widget.splitMinute!) *
          widget.splitMinute!;
      minute = minute >= 60 ? minute - 60 : minute;
      _currentValue = DateTime(
        _currentValue.year,
        _currentValue.month,
        _currentValue.day,
        _currentValue.hour,
        minute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (widget.drumRollType) {
          case DrumRollType.date:
            DatePicker.showDatePicker(
              context,
              locale: LocaleType.jp,
              onChanged: (date) {
                widget.onChanged?.call(date);
              },
              onConfirm: (date) {
                widget.onConfirm(date);
                _currentValue = date;
                setState(() {});
              },
              minTime: widget.minDate,
              maxTime: widget.maxDate,
              currentTime: _currentValue,
            );
            break;
          case DrumRollType.time:
            DatePicker.showPicker(
              context,
              locale: LocaleType.jp,
              onChanged: (date) {
                widget.onChanged?.call(date);
              },
              onConfirm: (date) {
                widget.onConfirm(date);
                _currentValue = date;
                setState(() {});
              },
              pickerModel: CustomPicker(
                splitMinute: widget.splitMinute ?? 1,
                currentTime: _currentValue,
              ),
            );
            break;
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorName.drumRollButtonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: CustomText(
          text: widget.drumRollType == DrumRollType.time
              ? DateFormat('HH:mm').format(_currentValue)
              : DateFormat('yyyy/MM/dd').format(_currentValue),
          color: ColorName.subColor,
        ),
      ),
    );
  }
}
