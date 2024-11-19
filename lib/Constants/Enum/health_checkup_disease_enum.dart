enum HealthCheckupDiseaseEnum {
  goodHealth,
  highFever,
  badFeel,
  painfulChest,
  painfulStomach,
  painfulHead,
}

class HealthCheckupDiseaseType {
  static HealthCheckupDiseaseEnum fromString(String value) {
    switch (value) {
      case 'goodHealth':
        return HealthCheckupDiseaseEnum.goodHealth;
      case 'highFever':
        return HealthCheckupDiseaseEnum.highFever;
      case 'badFeel':
        return HealthCheckupDiseaseEnum.badFeel;
      case 'painfulChest':
        return HealthCheckupDiseaseEnum.painfulChest;
      case 'painfulStomach':
        return HealthCheckupDiseaseEnum.painfulStomach;
      case 'painfulHead':
        return HealthCheckupDiseaseEnum.painfulHead;
      default:
        throw Exception('Unknown HealthCheckupDiseaseEnum value: $value');
    }
  }

  static String toStringValue(HealthCheckupDiseaseEnum value) {
    switch (value) {
      case HealthCheckupDiseaseEnum.goodHealth:
        return '健康';
      case HealthCheckupDiseaseEnum.highFever:
        return '高熱';
      case HealthCheckupDiseaseEnum.badFeel:
        return '気分が悪い';
      case HealthCheckupDiseaseEnum.painfulChest:
        return '胸が痛い';
      case HealthCheckupDiseaseEnum.painfulStomach:
        return 'お腹が痛い';
      case HealthCheckupDiseaseEnum.painfulHead:
        return '頭が痛い';
      default:
        throw Exception('Unknown HealthCheckupDiseaseEnum value: $value');
    }
  }
}
