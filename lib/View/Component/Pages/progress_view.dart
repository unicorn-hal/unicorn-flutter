import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Controller/Component/Pages/Register/Progress/progress_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({
    super.key,
    required this.from,
    this.diseaseEnumString,
    this.healthPoint,
    this.diseaseType,
  });

  final String from;
  final String? diseaseEnumString;
  final int? healthPoint;
  final HealthCheckupDiseaseEnum? diseaseType;

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  late final ProgressController controller;

  @override
  void initState() {
    super.initState();

    controller = ProgressController(
        context: context,
        from: widget.from,
        healthPoint: widget.healthPoint,
        diseaseType: widget.diseaseType,
        diseaseEnumString: widget.diseaseEnumString);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      isAppbar: false,
      body: ValueListenableBuilder<String>(
          valueListenable: controller.bodyText,
          builder: (context, value, child) {
            return Center(
              child: CustomLoadingAnimation(
                text: value,
                iconColor: ColorName.textGray,
                textColor: ColorName.textGray,
              ),
            );
          }),
    );
  }
}
