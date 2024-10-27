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
    this.initValue,
    this.maxDate,
    this.splitMinute,
  });

  final DrumRollType drumRollType;
  final DateTime? initValue;
  final DateTime? maxDate;
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
      _currentValue = DateTime(
        _currentValue.year,
        _currentValue.month,
        _currentValue.day,
        _currentValue.hour,
        _currentValue.minute - _currentValue.minute % widget.splitMinute!,
      );
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
            _currentValue = date;
            setState(() {});
          },
          pickerModel: CustomPicker(
            drumRollType: widget.drumRollType,
            maxDate: widget.maxDate,
            splitMinute: widget.splitMinute ?? 1,
            currentTime: _currentValue,
          ),
        );
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
              : DateFormat('yyyy MM/dd').format(_currentValue),
          color: Colors.blue,
        ),
      ),
    );
  }
}
