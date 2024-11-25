import 'dart:math';

import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';

class ProgressController extends ControllerCore {
  ProgressController({
    required this.context,
    required super.from,
    this.diseaseEnumString,
    this.healthPoint,
    this.diseaseType,
  });

  BuildContext context;
  String? diseaseEnumString;
  int? healthPoint;
  HealthCheckupDiseaseEnum? diseaseType;

  late ValueNotifier<String> _bodyText;

  @override
  void initialize() {
    if (from == Routes.emergency) {
      _bodyText = ValueNotifier(typeToText(ProgressViewEnum.inspection));
    } else {
      _bodyText = ValueNotifier(typeToText(ProgressViewEnum.bodyTemperature));
    }
    delayEvent();
  }

  Future<void> delayEvent() async {
    await Future.delayed(const Duration(seconds: 3));

    // 3秒後に表示するテキストを変更
    if (from == Routes.emergency) {
      _bodyText.value = typeToText(ProgressViewEnum.treatment);
    } else {
      _bodyText.value = typeToText(ProgressViewEnum.bloodPressure);
    }
    await Future.delayed(const Duration(seconds: 3));
    String bodyTemperature = _generateRandomBodyTemperature().toString();
    String bloodPressure = _generateRandomBloodPressure();
    // それぞれの画面に遷移
    if (from == Routes.emergency) {
      // todo: 画面遷移
    } else if (from == Routes.normalCheckup) {
      // todo: 結果画面に必要な情報はあとから修正

      CheckupResultRoute(
        $extra: diseaseType,
        healthPoint: healthPoint,
        bodyTemperature: bodyTemperature,
        bloodPressure: bloodPressure,
      ).go(context);
    } else if (from == Routes.healthCheckupAi) {
      CheckupResultRoute(
        diseaseEnumString: diseaseEnumString,
        bodyTemperature: bodyTemperature,
        bloodPressure: bloodPressure,
      ).go(context);
    }
  }

  /// enumからテキストに変換
  String typeToText(ProgressViewEnum type) {
    switch (type) {
      case ProgressViewEnum.inspection:
        return Strings.LOADING_TEXT_INSPECTION;
      case ProgressViewEnum.treatment:
        return Strings.LOADING_TEXT_TREATMENT;
      case ProgressViewEnum.bodyTemperature:
        return Strings.LOADING_TEXT_BODY_TEMPERATURE;
      case ProgressViewEnum.bloodPressure:
        return Strings.LOADING_TEXT_BLOOD_PRESSURE;
      default:
        return '';
    }
  }

  /// 正常値の範囲でランダムな体温を生成
  double _generateRandomBodyTemperature() {
    Random random = Random();
    double temp = 36.0 + random.nextDouble() * 1.5; // 36.0°C から 37.5°C の範囲
    return double.parse(temp.toStringAsFixed(1)); // 小数点第1位までに丸める
  }

  /// 正常値の範囲でランダムな血圧を生成
  String _generateRandomBloodPressure() {
    Random random = Random();
    int systolic = 90 + random.nextInt(30); // 90 から 120 の範囲
    int diastolic = 60 + random.nextInt(20); // 60 から 80 の範囲
    return '$systolic/$diastolic';
  }

  ValueNotifier<String> get bodyText => _bodyText;
}
