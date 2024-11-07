import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/day_of_week_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/reminder.dart';
import 'package:uuid/uuid.dart';

class MedicineSettingController extends ControllerCore {
  /// Serviceのインスタンス化

  /// コンストラクタ
  MedicineSettingController(this.medicine);
  Medicine? medicine;

  /// 変数の定義
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController();
  int? selectIndex = 0;
  List<Reminder> reminders = [];

  /// initialize()
  @override
  void initialize() {
    if (medicine != null) {
      nameController.text = medicine!.medicineName;
      countController.text = medicine!.count.toString();
      // selectIndex = medicine!.服用量 - 1;
      if (medicine!.reminders.isNotEmpty) {
        reminders.addAll(medicine!.reminders);
      }
    }
  }

  /// 各関数の実装
  DateTime changeDateTime(int index) {
    return DateTime.parse(
        '${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${reminders[index].reminderTime}');
  }

  void addReminders() {
    DateTime now = DateTime.now();
    String reminderId = const Uuid().v4();
    List<DayOfWeekEnum> reminderDayOfWeek = [
      DayOfWeekEnumType.fromWeekday(now.weekday)
    ];
    DateTime formatTime = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute - now.minute % 15,
    );
    String reminderTime = DateFormat('HH:mm').format(formatTime);
    Reminder reminder = Reminder(
        reminderId: reminderId,
        reminderTime: reminderTime,
        reminderDayOfWeek: reminderDayOfWeek);
    reminders.add(reminder);
  }
}
