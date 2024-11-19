import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';

class ProgressCheckupController extends ControllerCore {
  ProgressCheckupController({
    required this.context,
    required super.from,
    required this.diseaseEnumString,
  });

  BuildContext context;
  final String diseaseEnumString;
  @override
  void initialize() {
    print('initialize');
    print(super.from);
    navigation();
  }

  Future<void> navigation() async {
    await delayEvent(super.from!);
  }

  Future<void> delayEvent(String from) async {
    await Future.delayed(const Duration(seconds: 3));
    if (from == Routes.healthCheckupProgress) {
      // todo: のり塩作業分があるので渡す直前まで記述、後で修正
      // 渡す値は、diseaseEnum,bloodPressure,bodyTemperature,pointの4つ
      // でっちあげ値を生成して渡す
      final HealthCheckupDiseaseEnum diseaseEnum =
          HealthCheckupDiseaseType.fromString(diseaseEnumString);
      final String bloodPressure = '120/80';
      final String bodyTemperature = '36.5';
      final int point = 100;

      CheckupResultRoute().push(context);
      return;
    }
    // 血圧を測る画面に遷移
    CheckupProgressRoute(
      $extra: ProgressViewEnum.bloodPressure,
      from: Routes.healthCheckupProgress,
      diseaseEnumString: diseaseEnumString,
    ).push(context);
    return;
  }
}
