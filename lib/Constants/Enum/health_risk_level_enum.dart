import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';

enum HealthRiskLevelEnum {
  low,
  medium,
  high,
}

class HealthRiskLevelType {
  static String getHealthRiskLevelString(HealthRiskLevelEnum healthRiskLevel) {
    switch (healthRiskLevel) {
      case HealthRiskLevelEnum.low:
        return Strings.HEALTH_CHECKUP_RESULT_RISK_LEVEL_LOW;
      case HealthRiskLevelEnum.medium:
        return Strings.HEALTH_CHECKUP_RESULT_RISK_LEVEL_MEDIUM;
      case HealthRiskLevelEnum.high:
        return Strings.HEALTH_CHECKUP_RESULT_RISK_LEVEL_HIGH;
      default:
        throw Exception('Unknown healthRiskLevel: $healthRiskLevel');
    }
  }

  static Color getHealthRiskLevelColor(HealthRiskLevelEnum healthRiskLevel) {
    switch (healthRiskLevel) {
      case HealthRiskLevelEnum.low:
        return Colors.blue;
      case HealthRiskLevelEnum.medium:
        return Colors.orange;
      case HealthRiskLevelEnum.high:
        return Colors.red;
      default:
        throw Exception('Unknown healthRiskLevel: $healthRiskLevel');
    }
  }
}
