import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({
    super.key,
    required this.progressType,
  });

  final ProgressViewEnum progressType;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: CustomLoadingAnimation(
          text: ProgressViewType.typeToText(progressType),
          iconColor: ColorName.textGray,
          textColor: ColorName.textGray,
        ),
      ),
    );
  }
}
