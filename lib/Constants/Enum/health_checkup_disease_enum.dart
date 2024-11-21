import 'package:unicorn_flutter/Constants/disease_example_name_list.dart';
import 'package:unicorn_flutter/Constants/disease_text_list.dart';

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

  static List<String> getDiseaseTextList(HealthCheckupDiseaseEnum value) {
    switch (value) {
      case HealthCheckupDiseaseEnum.goodHealth:
        return DiseaseTextList.goodHealthTextList;
      case HealthCheckupDiseaseEnum.highFever:
        return DiseaseTextList.highFeverTextList;
      case HealthCheckupDiseaseEnum.badFeel:
        return DiseaseTextList.badFeelTextList;
      case HealthCheckupDiseaseEnum.painfulChest:
        return DiseaseTextList.painfulChestTextList;
      case HealthCheckupDiseaseEnum.painfulStomach:
        return DiseaseTextList.painfulStomachTextList;
      case HealthCheckupDiseaseEnum.painfulHead:
        return DiseaseTextList.painfulHeadTextList;
      default:
        throw Exception('Unknown HealthCheckupDiseaseEnum value: $value');
    }
  }

  static List<String> getDiseaseExampleNameList(
      HealthCheckupDiseaseEnum value) {
    switch (value) {
      case HealthCheckupDiseaseEnum.goodHealth:
        return DiseaseExampleNameList.goodHealthExampleNameList;
      case HealthCheckupDiseaseEnum.highFever:
        return DiseaseExampleNameList.highFeverExampleNameList;
      case HealthCheckupDiseaseEnum.badFeel:
        return DiseaseExampleNameList.badFeelExampleNameList;
      case HealthCheckupDiseaseEnum.painfulChest:
        return DiseaseExampleNameList.painfulChestExampleNameList;
      case HealthCheckupDiseaseEnum.painfulStomach:
        return DiseaseExampleNameList.painfulStomachExampleNameList;
      case HealthCheckupDiseaseEnum.painfulHead:
        return DiseaseExampleNameList.painfulHeadExampleNameList;
      default:
        throw Exception('Unknown HealthCheckupDiseaseEnum value: $value');
    }
  }
}
