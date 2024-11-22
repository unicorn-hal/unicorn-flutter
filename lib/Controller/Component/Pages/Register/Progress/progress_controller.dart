import 'package:flutter/material.dart';
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
  });

  BuildContext context;
  String? diseaseEnumString;

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

    // それぞれの画面に遷移
    if (from == Routes.emergency) {
      // todo: 画面遷移
    } else {
      // todo: 結果画面に必要な情報はあとから修正
      CheckupResultRoute().go(context);
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

  ValueNotifier<String> get bodyText => _bodyText;
}
