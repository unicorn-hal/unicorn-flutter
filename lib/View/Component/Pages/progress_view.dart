import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Controller/HealthCheckup/progress_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({
    super.key,
    required this.diseaseType,
    required this.healthPoint,
  });

  final HealthCheckupDiseaseEnum diseaseType;
  final int healthPoint;

  @override
  Widget build(BuildContext context) {
    ProgressController controller = ProgressController(context, diseaseType);

    return CustomScaffold(
      body: Center(
        child: StreamBuilder<String>(
          stream: controller.progressStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CustomLoadingAnimation(
                    text: snapshot.data!,
                    iconColor: ColorName.textGray,
                    textColor: ColorName.textGray,
                  ),
                  const SizedBox(height: 20),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
