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
  /// Stringの時間をDateTime型に変換する関数
  DateTime changeDateTime(int index) {
    return DateTime.parse(
        '${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${reminders[index].reminderTime}');
  }

  ///リマインダーに初期値を入れ、追加する関数
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

  ///リマインダーを削除する関数
  void deleteReminders(int index) {
    reminders.removeAt(index);
  }

  ///リマインダーに登録されている時間を更新する
  void updateReminderTime({required DateTime date, required int index}) {
    DateTime formatTime = DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute - date.minute % 15,
    );
    String reminderTime = DateFormat('HH:mm').format(formatTime);
    reminders[index] = Reminder(
        reminderId: reminders[index].reminderId,
        reminderTime: reminderTime,
        reminderDayOfWeek: reminders[index].reminderDayOfWeek);
  }

  ///リマインダーの曜日listに曜日を追加する関数
  void addReminderDayOfWeek({required int remindersIndex, required int index}) {
    if (!reminders[remindersIndex]
        .reminderDayOfWeek
        .contains(DayOfWeekEnumType.fromWeekday(index + 1))) {
      reminders[remindersIndex]
          .reminderDayOfWeek
          .add(DayOfWeekEnumType.fromWeekday(index + 1));
      return;
    }
    reminders[remindersIndex]
        .reminderDayOfWeek
        .remove(DayOfWeekEnumType.fromWeekday(index + 1));
    return;
  }

  ///intから漢字の曜日に変える関数
  String changeWeekday(int index) {
    return DayOfWeekEnumType.toStringValueForKanji(
        DayOfWeekEnumType.fromWeekday(index + 1));
  }

  ///reminderDayOfWeekに選択した曜日があるかチェックする関数
  bool checkReminderDayOfWeek(
      {required int remindersIndex, required int index}) {
    return reminders[remindersIndex]
        .reminderDayOfWeek
        .contains(DayOfWeekEnumType.fromWeekday(index + 1));
  }

  ///reminderDayOfWeekを表示する形に成形する関数
  String moldingReminderDayOfWeek(int index) {
    String displayedReminderDayOfWeek = '';
    if (reminders[index].reminderDayOfWeek.length == 7) {
      return '毎日';
    }
    if (reminders[index].reminderDayOfWeek.length == 1) {
      return '毎${DayOfWeekEnumType.toStringValueForKanji(reminders[index].reminderDayOfWeek[0])}曜日';
    }
    for (var i = 0; i < reminders[index].reminderDayOfWeek.length; i++) {
      //ソート
      if (i == 0) {
        displayedReminderDayOfWeek =
            '$displayedReminderDayOfWeek${DayOfWeekEnumType.toStringValueForKanji(reminders[index].reminderDayOfWeek[i])}';
      } else {
        displayedReminderDayOfWeek =
            '$displayedReminderDayOfWeek,${DayOfWeekEnumType.toStringValueForKanji(reminders[index].reminderDayOfWeek[i])}';
      }
    }
    return displayedReminderDayOfWeek;
  }
}
