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
    required this.healthPoint,
    required this.diseaseType,
  });

  BuildContext context;
  int healthPoint;
  HealthCheckupDiseaseEnum diseaseType;

  final double _normalBodyTempMin = 36.0;
  final double _normalBodyTempMax = 37.5;
  final int _normalSystolicMin = 90;
  final int _normalSystolicMax = 120;
  final int _normalDiastolicMin = 60;
  final int _normalDiastolicMax = 80;

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

    double bodyTemperature = _generateRandomBodyTemperature();
    String bloodPressure = _generateRandomBloodPressure();

    healthPoint = _updateHealthPoint(bodyTemperature, bloodPressure);
    // それぞれの画面に遷移
    if (from == Routes.emergency) {
      // todo: 画面遷移
    } else {
      CheckupResultRoute(
        $extra: diseaseType,
        healthPoint: healthPoint,
        bodyTemperature: bodyTemperature.toString(),
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
    return _normalBodyTempMin + random.nextDouble() * 1.5; // 36.0 から 37.5 の範囲
  }

  /// 正常値の範囲でランダムな血圧を生成
  String _generateRandomBloodPressure() {
    Random random = Random();
    int systolic = _normalSystolicMin + random.nextInt(30); // 90 から 120 の範囲
    int diastolic = _normalDiastolicMin + random.nextInt(20); // 60 から 80 の範囲
    return '$systolic/$diastolic';
  }

  int _updateHealthPoint(double bodyTemperature, String bloodPressure) {
    // 体温の評価
    if (bodyTemperature < _normalBodyTempMin - 0.5 ||
        bodyTemperature > _normalBodyTempMax + 0.5) {
      healthPoint += 3; // 大きく正常値範囲外ならhealthPointを大幅に増加
    } else if (bodyTemperature < _normalBodyTempMin ||
        bodyTemperature > _normalBodyTempMax) {
      healthPoint += 2; // 少し正常値範囲外ならhealthPointを少し増加
    } else {
      healthPoint -= 3; // 正常値範囲内ならhealthPointを減少
    }

    // 血圧の評価
    List<String> bpValues = bloodPressure.split('/');
    int systolic = int.parse(bpValues[0]);
    int diastolic = int.parse(bpValues[1]);

    if (systolic < _normalSystolicMin - 10 ||
        systolic > _normalSystolicMax + 10 ||
        diastolic < _normalDiastolicMin - 10 ||
        diastolic > _normalDiastolicMax + 10) {
      return healthPoint += 3; // 大きく正常値範囲外ならhealthPointを大幅に増加
    } else if (systolic < _normalSystolicMin ||
        systolic > _normalSystolicMax ||
        diastolic < _normalDiastolicMin ||
        diastolic > _normalDiastolicMax) {
      return healthPoint += 2; // 少し正常値範囲外ならhealthPointを少し増加
    } else {
      return healthPoint -= 2; // 正常値範囲内ならhealthPointを減少
    }
  }

  ValueNotifier<String> get bodyText => _bodyText;
}
