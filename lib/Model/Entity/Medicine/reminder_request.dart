import 'package:unicorn_flutter/Constants/Enum/day_of_week_enum.dart';

class ReminderRequest {
  final String reminderTime;
  final List<DayOfWeekEnum> reminderDayOfWeek;

  ReminderRequest({
    required this.reminderTime,
    required this.reminderDayOfWeek,
  });

  factory ReminderRequest.fromJson(Map<String, dynamic> json) {
    return ReminderRequest(
      reminderTime: json['reminderTime'],
      reminderDayOfWeek: (json['reminderDayOfWeek'] as List)
          .map((e) => DayOfWeekEnumType.fromString(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminderTime': reminderTime,
      'reminderDayOfWeek': reminderDayOfWeek
          .map((e) => DayOfWeekEnumType.toStringValue(e))
          .toList(),
    };
  }
}
