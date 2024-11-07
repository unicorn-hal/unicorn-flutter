import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/reminder.dart';

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
        '${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${medicine!.reminders[index].reminderTime}');
  }

  void addReminders() {}
}
