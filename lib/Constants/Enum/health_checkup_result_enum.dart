import 'package:flutter/material.dart';

enum HealthCheckupResultEnum {
  //　体温・血圧共に基準値内
  normal,
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
      case 'normal':
        return HealthCheckupResultEnum.normal;
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

  static String typeTitle(HealthCheckupResultEnum type) {
    switch (type) {
      case HealthCheckupResultEnum.normal:
        return "正常";
      case HealthCheckupResultEnum.bodyTemperatureHazard:
      case HealthCheckupResultEnum.bloodPressureHazard:
        return "要注意";
      case HealthCheckupResultEnum.danger:
        return "危険";

      default:
        return "正常";
    }
  }

  static String typeDescription(HealthCheckupResultEnum type) {
    switch (type) {
      case HealthCheckupResultEnum.normal:
        return "体温・血圧ともに平均値です。体調が優れない場合は医師との通話やAIチャットを利用してください。";
      case HealthCheckupResultEnum.bodyTemperatureHazard:
        return "体温が平均値から外れています。体調が優れない場合は医師との通話やAIチャットを利用してください。";
      case HealthCheckupResultEnum.bloodPressureHazard:
        return "血圧が平均値から外れています。体調が優れない場合は医師との通話やAIチャットを利用してください。";
      case HealthCheckupResultEnum.danger:
        return "体温・血圧ともに平均値から外れています。緊急時は医師との通話やAIチャットを利用してください。";
      default:
        return "体温・血圧ともに平均値です。体調が優れない場合は医師との通話やAIチャットを利用してください。";
    }
  }

  static Color typeColor(HealthCheckupResultEnum type) {
    switch (type) {
      case HealthCheckupResultEnum.normal:
        return Colors.green;
      case HealthCheckupResultEnum.bodyTemperatureHazard:
      case HealthCheckupResultEnum.bloodPressureHazard:
        return Colors.orange;
      case HealthCheckupResultEnum.danger:
        return Colors.red;
      default:
        return Colors.green;
    }
  }
}
