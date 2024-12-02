import 'package:unicorn_flutter/Constants/Enum/day_of_week_enum.dart';

class Reminder {
  final String reminderId;
  final String reminderTime;
  final List<DayOfWeekEnum> reminderDayOfWeek;

  Reminder({
    required this.reminderId,
    required this.reminderTime,
    required this.reminderDayOfWeek,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      reminderId: json['reminderID'],
      reminderTime: json['reminderTime'],
      reminderDayOfWeek: (json['reminderDayOfWeek'] as List)
          .map((e) => DayOfWeekEnumType.fromString(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reminderID': reminderId,
      'reminderTime': reminderTime,
      'reminderDayOfWeek': reminderDayOfWeek
          .map((e) => DayOfWeekEnumType.toStringValue(e))
          .toList(),
    };
  }
}
