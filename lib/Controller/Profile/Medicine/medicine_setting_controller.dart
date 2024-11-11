import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/day_of_week_enum.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine_request.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/reminder.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/reminder_request.dart';
import 'package:unicorn_flutter/Service/Api/Medicine/medicine_api.dart';
import 'package:uuid/uuid.dart';

class MedicineSettingController extends ControllerCore {
  /// Serviceのインスタンス化
  MedicineApi get _medicineApi => MedicineApi();

  /// コンストラクタ
  MedicineSettingController(this._medicine);
  final Medicine? _medicine;

  /// 変数の定義
  TextEditingController nameController = TextEditingController();
  TextEditingController countController = TextEditingController();
  int? _selectIndex = 0;
  late List<Reminder> _reminders;
  late List<DayOfWeekEnum> _reminderDayOfWeekList;

  /// initialize()
  @override
  void initialize() {
    _reminders = <Reminder>[];
    _reminderDayOfWeekList = <DayOfWeekEnum>[];
    if (_medicine != null) {
      nameController.text = _medicine.medicineName;
      countController.text = _medicine.quantity.toString();
      _selectIndex = _medicine.dosage - 1;
      if (_medicine.reminders.isNotEmpty) {
        _reminders.addAll(_medicine.reminders);
      }
    }
  }

  /// 各関数の実装
  int? get selectIndex => _selectIndex;
  void setSelectIndex(int? value) {
    _selectIndex = value;
  }

  List<Reminder> get reminders => _reminders;

  /// String型で受け取ったreminderTimeをDateTime型に変換する関数
  DateTime changeDateTime({required int index}) {
    return DateTime.parse(
        '${DateFormat('yyyy-MM-dd').format(DateTime.now())} ${_reminders[index].reminderTime}');
  }

  /// リマインダーに初期値を入れ、remindersに追加する関数
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
    _reminders.add(reminder);
  }

  /// remindersから選択されたリマインダーを削除する関数
  void deleteReminders({required int index}) {
    _reminders.removeAt(index);
  }

  /// リマインダーに登録されている時間を更新する関数
  void updateReminderTime({required DateTime date, required int index}) {
    DateTime formatTime = DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      date.minute - date.minute % 15,
    );
    String reminderTime = DateFormat('HH:mm').format(formatTime);
    _reminders[index] = Reminder(
      reminderId: _reminders[index].reminderId,
      reminderTime: reminderTime,
      reminderDayOfWeek: _reminders[index].reminderDayOfWeek,
    );
  }

  /// Modalで使用するためにDayOfWeekEnum型のListを複製する関数
  List<DayOfWeekEnum> copyReminderDayOfWeek({required int index}) {
    _reminderDayOfWeekList = [..._reminders[index].reminderDayOfWeek];
    return _reminderDayOfWeekList;
  }

  void resetReminderDayOfWeekList() {
    _reminderDayOfWeekList = [];
  }

  /// reminderDayOfWeekに曜日を追加、削除する関数
  void changeReminderDayOfWeekList({required int index}) {
    if (!_reminderDayOfWeekList
        .contains(DayOfWeekEnumType.fromWeekday(index + 1))) {
      _reminderDayOfWeekList.add(DayOfWeekEnumType.fromWeekday(index + 1));
      return;
    }
    if (_reminderDayOfWeekList.length <= 1) {
      return;
    }
    _reminderDayOfWeekList.remove(DayOfWeekEnumType.fromWeekday(index + 1));
    return;
  }

  /// intからModalに表示する漢字表記の曜日に変える関数
  String getDayAbbreviation({required int index}) {
    return DayOfWeekEnumType.toDayAbbreviation(
        DayOfWeekEnumType.fromWeekday(index + 1));
  }

  /// reminderDayOfWeekに選択した曜日があるかチェックする関数
  bool checkReminderDayOfWeekList({required int index}) {
    return _reminderDayOfWeekList
        .contains(DayOfWeekEnumType.fromWeekday(index + 1));
  }

  /// Modalの決定ボタンが押されたときにreminderDayOfWeekListの値をreminders[index].reminderDayOfWeekに入れる関数
  void updateReminderDayOfWeek({required int index}) {
    _reminders[index] = Reminder(
        reminderId: _reminders[index].reminderId,
        reminderTime: _reminders[index].reminderTime,
        reminderDayOfWeek: _reminderDayOfWeekList);
  }

  /// reminderDayOfWeekをMedicineSettingViewに表示する形に成形する関数
  String moldingReminderDayOfWeek({required int index}) {
    String displayedReminderDayOfWeek = '';
    if (_reminders[index].reminderDayOfWeek.length == 7) {
      return '毎日';
    }
    if (_reminders[index].reminderDayOfWeek.length == 1) {
      return '毎${DayOfWeekEnumType.toDayAbbreviation(_reminders[index].reminderDayOfWeek[0])}曜日';
    }
    _reminders[index].reminderDayOfWeek.sort((a, b) => a.index - b.index);
    for (int i = 0; i < _reminders[index].reminderDayOfWeek.length; i++) {
      if (i == 0) {
        displayedReminderDayOfWeek =
            '$displayedReminderDayOfWeek${DayOfWeekEnumType.toDayAbbreviation(_reminders[index].reminderDayOfWeek[i])}';
      } else {
        displayedReminderDayOfWeek =
            '$displayedReminderDayOfWeek,${DayOfWeekEnumType.toDayAbbreviation(_reminders[index].reminderDayOfWeek[i])}';
      }
    }
    return displayedReminderDayOfWeek;
  }

  /// List<Reminder>型のremindersをList<ReminderRequest>型に変換する関数
  List<ReminderRequest> _createReminderRequestList(
      {required List<Reminder> reminders}) {
    List<ReminderRequest> reminderRequestList = [];
    for (int i = 0; i < reminders.length; i++) {
      reminderRequestList.add(reminders[i].toRequest());
    }
    return reminderRequestList;
  }

  /// Medicineの情報を更新する関数
  Future<void> putMedicine() async {
    if (!validateField()) {
      return;
    }
    MedicineRequest body = MedicineRequest(
      medicineName: nameController.text,
      count: _medicine!.count,
      quantity: int.parse(countController.text),
      dosage: _selectIndex! + 1,
      reminders: _createReminderRequestList(reminders: _reminders),
    );
    await _medicineApi.putMedicine(
        body: body, medicineId: _medicine.medicineId);
  }

  /// Medicineの情報を登録する関数
  Future<void> postMedicine() async {
    if (!validateField()) {
      return;
    }
    MedicineRequest body = MedicineRequest(
      medicineName: nameController.text,
      count: int.parse(countController.text),
      quantity: int.parse(countController.text),
      dosage: _selectIndex! + 1,
      reminders: _createReminderRequestList(reminders: _reminders),
    );
    await _medicineApi.postMedicine(body: body);
  }

  /// Medicineの情報を削除する関数
  Future<void> deleteMedicine() async {
    await _medicineApi.deleteMedicine(medicineId: _medicine!.medicineId);
  }

  /// TextEditingControllerが空文字でないかチェックする関数
  bool validateField() {
    if ((countController.text == '') || (nameController.text == '')) {
      Fluttertoast.showToast(msg: Strings.MEDICINE_VALIDATE_TEXT);
      return false;
    }
    return true;
  }
}
