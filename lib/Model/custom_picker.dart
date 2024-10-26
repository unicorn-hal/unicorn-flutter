import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomPicker extends CommonPickerModel {
  CustomPicker({
    required DateTime? currentTime,
    required LocaleType locale,
    required this.minute,
  }) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    setLeftIndex(this.currentTime.hour);
    setMiddleIndex(this.currentTime.minute ~/ minute);
    setRightIndex(0);
  }
  final int minute;

  String digits(int value, int length) => '$value'.padLeft(length, '0');

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < 60 ~/ minute) {
      return digits(index * minute, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() => ':';

  @override
  String rightDivider() => '';

  @override
  List<int> layoutProportions() => [1, 1, 0];

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentLeftIndex(),
            currentMiddleIndex() * minute,
            currentRightIndex(),
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            currentLeftIndex(),
            currentMiddleIndex() * minute,
            currentRightIndex(),
          );
  }
}
