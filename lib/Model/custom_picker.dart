import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class CustomPicker extends CommonPickerModel {
  final int splitMinute;

  CustomPicker({
    super.locale = LocaleType.jp,
    this.splitMinute = 1,
    DateTime? currentTime,
  }) {
    /// 引数の有無で初期値を設定
    this.currentTime = currentTime ?? DateTime.now();

    setLeftIndex(this.currentTime.hour);
    setMiddleIndex(this.currentTime.minute ~/ splitMinute);
    setRightIndex(0);
  }

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
    if (index >= 0 && index < 60 ~/ splitMinute) {
      return digits(index * splitMinute, 2);
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    return null;
  }

  @override
  String leftDivider() => ':';

  @override
  String rightDivider() => '';

  @override
  List<int> layoutProportions() => [1, 1, 0];

  @override
  DateTime finalTime() => DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        currentLeftIndex(),
        currentMiddleIndex() * splitMinute,
        currentRightIndex(),
      );
}
