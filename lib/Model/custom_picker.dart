import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_drum_roll.dart';

class CustomPicker extends CommonPickerModel {
  final DrumRollType drumRollType;
  final int splitMinute;
  DateTime? maxDate;
  DateTime minDate = DateTime(1900, 1, 1, 0, 0, 0);

  CustomPicker({
    super.locale = LocaleType.jp,
    required this.drumRollType,
    this.splitMinute = 1,
    this.maxDate,
    DateTime? currentTime,
  }) {
    DateTime now = DateTime.now();
    this.currentTime = currentTime ?? now;
    maxDate ??= DateTime(2099, 12, 31, 23, 59, 59);

    switch (drumRollType) {
      case DrumRollType.date:
        setLeftIndex(this.currentTime.year);
        setMiddleIndex(this.currentTime.month);
        setRightIndex(this.currentTime.day);
        break;
      case DrumRollType.time:
        setLeftIndex(this.currentTime.hour);
        setMiddleIndex(this.currentTime.minute ~/ splitMinute);
        setRightIndex(0);
        break;
    }
  }

  String digits(int value, int length) => '$value'.padLeft(length, '0');

  @override
  String? leftStringAtIndex(int index) {
    switch (drumRollType) {
      case DrumRollType.date:
        if (index >= minDate.year && index <= maxDate!.year) {
          return '$index';
        } else {
          return null;
        }
      case DrumRollType.time:
        if (index >= 0 && index < 24) {
          return digits(index, 2);
        } else {
          return null;
        }
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    switch (drumRollType) {
      case DrumRollType.date:
        if (index >= minDate.month && index <= maxDate!.month) {
          return '$index';
        } else {
          return null;
        }
      case DrumRollType.time:
        if (index >= 0 && index < 60 ~/ splitMinute) {
          return digits(index * splitMinute, 2);
        } else {
          return null;
        }
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    switch (drumRollType) {
      case DrumRollType.date:
        if (index >= minDate.day && index <= maxDate!.day) {
          return '$index';
        } else {
          return null;
        }
      case DrumRollType.time:
        return null;
    }
  }

  @override
  String leftDivider() {
    switch (drumRollType) {
      case DrumRollType.date:
        return '/';
      case DrumRollType.time:
        return ':';
    }
  }

  @override
  String rightDivider() {
    switch (drumRollType) {
      case DrumRollType.date:
        return '/';
      case DrumRollType.time:
        return '';
    }
  }

  @override
  List<int> layoutProportions() {
    switch (drumRollType) {
      case DrumRollType.date:
        return [1, 1, 1];
      case DrumRollType.time:
        return [1, 1, 0];
    }
  }

  @override
  DateTime finalTime() {
    switch (drumRollType) {
      case DrumRollType.date:
        return DateTime(
          currentLeftIndex(),
          currentMiddleIndex(),
          currentRightIndex(),
        );
      case DrumRollType.time:
        return DateTime(
          currentTime.year,
          currentTime.month,
          currentTime.day,
          currentLeftIndex(),
          currentMiddleIndex() * splitMinute,
          currentRightIndex(),
        );
    }
  }

  // CustomPicker({
  //   required DateTime? currentTime,
  //   required LocaleType locale,
  //   required this.minute,
  // }) : super(locale: locale) {
  //   this.currentTime = currentTime ?? DateTime.now();
  //   setLeftIndex(this.currentTime.hour);
  //   setMiddleIndex(this.currentTime.minute ~/ minute);
  //   setRightIndex(0);
  // }
  // final int minute;

  // String digits(int value, int length) => '$value'.padLeft(length, '0');

  // @override
  // String? leftStringAtIndex(int index) {
  //   if (index >= 0 && index < 24) {
  //     return digits(index, 2);
  //   } else {
  //     return null;
  //   }
  // }

  // @override
  // String? middleStringAtIndex(int index) {
  //   if (index >= 0 && index < 60 ~/ minute) {
  //     return digits(index * minute, 2);
  //   } else {
  //     return null;
  //   }
  // }

  // @override
  // String leftDivider() => ':';

  // @override
  // String rightDivider() => '';

  // @override
  // List<int> layoutProportions() => [1, 1, 0];

  // @override
  // DateTime finalTime() {
  //   return currentTime.isUtc
  //       ? DateTime.utc(
  //           currentTime.year,
  //           currentTime.month,
  //           currentTime.day,
  //           currentLeftIndex(),
  //           currentMiddleIndex() * minute,
  //           currentRightIndex(),
  //         )
  //       : DateTime(
  //           currentTime.year,
  //           currentTime.month,
  //           currentTime.day,
  //           currentLeftIndex(),
  //           currentMiddleIndex() * minute,
  //           currentRightIndex(),
  //         );
  // }
}
