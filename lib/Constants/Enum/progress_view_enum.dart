import '../strings.dart';

enum ProgressViewEnum {
  inspection,
  treatment,
  bodyTemperature,
  bloodPressure,
}

class ProgressViewType {
  static typeToText(ProgressViewEnum type) {
    switch (type) {
      case ProgressViewEnum.inspection:
        return Strings.LOADING_TEXT_INSPECTION;
      case ProgressViewEnum.treatment:
        return Strings.LOADING_TEXT_TREATMENT;
      case ProgressViewEnum.bodyTemperature:
        return Strings.LOADING_TEXT_BODY_TEMPERATURE;
      case ProgressViewEnum.bloodPressure:
        return Strings.LOADING_TEXT_BLOOD_PRESSURE;
    }
  }
}
