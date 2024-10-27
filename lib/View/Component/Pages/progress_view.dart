import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../../Constants/strings.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({
    super.key,
    required this.progressType,
  });

  final ProgressViewEnum progressType;

  // todo: controllerに移植する
  // enumからテキストに変換
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
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: CustomLoadingAnimation(
          text: typeToText(progressType),
          iconColor: ColorName.textGray,
          textColor: ColorName.textGray,
        ),
      ),
    );
  }
}
