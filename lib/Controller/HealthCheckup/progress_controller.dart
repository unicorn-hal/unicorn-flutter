import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Route/router.dart';

class ProgressController extends ControllerCore {
  /// Serviceのインスタンス化

  /// コンストラクタ
  BuildContext context;
  ProgressController(this.context, this._diseaseType);

  /// 変数の定義
  final List<ProgressViewEnum> _progressTypes = [
    ProgressViewEnum.inspection,
    ProgressViewEnum.treatment,
    ProgressViewEnum.bodyTemperature,
    ProgressViewEnum.bloodPressure,
  ];

  int _currentIndex = 0;
  final int _healthPoint = 0;
  final HealthCheckupDiseaseEnum _diseaseType;

  int get healthPoint => _healthPoint;
  HealthCheckupDiseaseEnum get diseaseType => _diseaseType;

  /// initialize()
  @override
  void initialize() {
    print('Controller Init');
  }

  /// 各関数の実装

  String typeToText(ProgressViewEnum progressType) {
    switch (progressType) {
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

  Stream<String> get progressStream async* {
    while (_currentIndex < _progressTypes.length) {
      yield typeToText(_progressTypes[_currentIndex]);
      await Future.delayed(const Duration(seconds: 4));
      _currentIndex++;

      if (_currentIndex >= _progressTypes.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CheckupResultRoute(
            $extra: _diseaseType,
            healthPoint: _healthPoint,
          ).push(context);
        });
      }
    }
  }
}
