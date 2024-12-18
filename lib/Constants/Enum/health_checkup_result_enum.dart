import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';

enum HealthCheckupResultEnum {
  //　体温・血圧共に基準値内
  safety,
  // 体温が基準値からはずれている
  bodyTemperatureHazard,
  // 血圧が基準値からはずれている
  bloodPressureHazard,
  // 体温・血圧共に基準値からはずれている
  danger,
}

class HealthCheckupResultType {
  static HealthCheckupResultEnum getHealthCheckupResultType(String type) {
    switch (type) {
      case 'safety':
        return HealthCheckupResultEnum.safety;
      case 'bodyTemperatureHazard':
        return HealthCheckupResultEnum.bodyTemperatureHazard;
      case 'bloodPressureHazard':
        return HealthCheckupResultEnum.bloodPressureHazard;
      case 'danger':
        return HealthCheckupResultEnum.danger;
      default:
        throw Exception('Unknown type: $type');
    }
  }

  static String title(HealthCheckupResultEnum type) {
    switch (type) {
      case HealthCheckupResultEnum.safety:
        return "正常";
      case HealthCheckupResultEnum.bodyTemperatureHazard:
        return "要注意";
      case HealthCheckupResultEnum.bloodPressureHazard:
        return "要注意";
      case HealthCheckupResultEnum.danger:
        return "危険";

      default:
        throw Exception('Unknown type: $type');
    }
  }

  static String description(HealthCheckupResultEnum type) {
    switch (type) {
      case HealthCheckupResultEnum.safety:
        return Strings.HEALTH_CHECKUP_RESULT_DESCRIPTION_SAFETY;
      case HealthCheckupResultEnum.bodyTemperatureHazard:
        return Strings
            .HEALTH_CHECKUP_RESULT_DESCRIPTION_BODY_TEMPERATURE_HAZARD;
      case HealthCheckupResultEnum.bloodPressureHazard:
        return Strings.HEALTH_CHECKUP_RESULT_DESCRIPTION_BLOOD_PRESSURE_HAZARD;
      case HealthCheckupResultEnum.danger:
        return Strings.HEALTH_CHECKUP_RESULT_DESCRIPTION_DANGER;
      default:
        throw Exception('Unknown type: $type');
    }
  }

  static Color color(HealthCheckupResultEnum type) {
    switch (type) {
      case HealthCheckupResultEnum.safety:
        return Colors.green;
      case HealthCheckupResultEnum.bodyTemperatureHazard:
        return Colors.orange;
      case HealthCheckupResultEnum.bloodPressureHazard:
        return Colors.orange;
      case HealthCheckupResultEnum.danger:
        return Colors.red;
      default:
        throw Exception('Unknown type: $type');
    }
  }
}
