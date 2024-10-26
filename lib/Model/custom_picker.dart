import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_drum_roll.dart';

class CustomPicker extends CommonPickerModel {
  final DrumRollType drumRollType;
  final int splitMinute;

  CustomPicker({
    super.locale = LocaleType.jp,
    required this.drumRollType,
    this.splitMinute = 1,
    DateTime? currentTime,
  }) {
    this.currentTime = currentTime ?? DateTime.now();

    switch (drumRollType) {
      case DrumRollType.date:
        setLeftIndex(DateTime.now().year - 1900);
        setMiddleIndex(DateTime.now().month - 1);
        setRightIndex(DateTime.now().day - 1);
        break;
      case DrumRollType.time:
        setLeftIndex(DateTime.now().hour);
        setMiddleIndex(DateTime.now().minute ~/ splitMinute);
        setRightIndex(0);
        break;
    }
  }

  String digits(int value, int length) => '$value'.padLeft(length, '0');

  @override
  String? leftStringAtIndex(int index) {
    switch (drumRollType) {
      case DrumRollType.date:
        if (index >= 0 && index < 200) {
          return '${index + 1900}';
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
        if (index >= 0 && index < 12) {
          return '${index + 1}';
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
        if (index >= 0 && index < 31) {
          return '${index + 1}';
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
          currentLeftIndex() + 1900,
          currentMiddleIndex() + 1,
          currentRightIndex() + 1,
        );
      case DrumRollType.time:
        return DateTime(
          0,
          0,
          0,
          currentLeftIndex(),
          currentMiddleIndex(),
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
