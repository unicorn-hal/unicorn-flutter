import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/day_of_week_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';

class HealthCheckupResultController extends ControllerCore {
  /// Serviceのインスタンス化

  /// コンストラクタ
  HealthCheckupResultController(
    this.context,
    this.diseaseType,
    this.healthPoint,
    this.bloodPressure,
    this.bodyTemperature,
  );
  BuildContext context;

  /// 変数の定義

  int healthPoint;
  HealthCheckupDiseaseEnum diseaseType;
  String bloodPressure;
  String bodyTemperature;
  String formattedDate = '';

  /// initialize()
  @override
  void initialize() {
    getTodayDate();
    print('Controller InitA');
  }

  /// 各関数の実装

  /// チェックアップ結果の取得
  void getCheckupResult() {
    if (healthPoint >= 10) {
      print('健康です');
    } else {
      print('病気です');
    }
  }

  void getTodayDate() {
    DateTime today = DateTime.now();
    String todayDatePart = DateFormat('MM/dd').format(today);
    String todayDayOfWeek = DateFormat('EEEE').format(today).toLowerCase();
    DayOfWeekEnum dayOfWeekEnum = DayOfWeekEnumType.fromString(todayDayOfWeek);
    String formattedDayOfWeek =
        DayOfWeekEnumType.toJapanseString(dayOfWeekEnum);
    formattedDate = '$todayDatePart($formattedDayOfWeek)';
  }
}
