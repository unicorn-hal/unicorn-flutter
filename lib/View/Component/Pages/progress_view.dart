import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/Controller/Component/Pages/Register/Progress/progress_checkup_controller.dart';
import 'package:unicorn_flutter/Controller/Component/Pages/Register/Progress/progress_emergency_controller.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../../Constants/strings.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({
    super.key,
    required this.progressType,
    required this.from,
    this.diseaseEnumString,
  });

  final ProgressViewEnum progressType;
  final String? diseaseEnumString;
  final String from;

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  late final controller;

  @override
  void initState() {
    super.initState();

    /// 遷移元によってコントローラーを選択
    controller = selectController(widget.from);
  }

  selectController(String from) {
    switch (from) {
      // ユニコーン要請からの場合、ProgressEmergencyController
      case Routes.emergency:
      case Routes.emergencyProgress:
        return ProgressEmergencyController();
      // 検診からの場合、ProgressCheckupController
      case Routes.healthCheckup:
      case Routes.healthCheckupAi:
      case Routes.healthCheckupProgress:
        return ProgressCheckupController(
          context: context,
          from: from,
          diseaseEnumString: widget.diseaseEnumString!,
        );
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

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbar: false,
      body: Center(
        child: CustomLoadingAnimation(
          text: typeToText(widget.progressType),
          iconColor: ColorName.textGray,
          textColor: ColorName.textGray,
        ),
      ),
    );
  }
}
