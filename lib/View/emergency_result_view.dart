import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/emergency_result_controller.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';

class EmergencyResultView extends StatelessWidget {
  const EmergencyResultView({
    super.key,
    required this.bodyTemperature,
    required this.bloodPressure,
  });

  final double bodyTemperature;
  final String bloodPressure;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    EmergencyResultController controller = EmergencyResultController(
      bodyTemperature: bodyTemperature,
      bloodPressure: bloodPressure,
    );

    return CustomScaffold(
      isAppbar: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.green),
              SizedBox(width: 10),
              CustomText(
                text: '緊急対応が完了しました',
              ),
            ],
          ),
          const SizedBox(height: 8),
          const CustomText(
            text: 'Unicornの対応履歴が記録されました',
            fontSize: 12,
            color: Colors.grey,
          ),
          const SizedBox(height: 64),
          CustomButton(
            text: 'ホームへ',
            onTap: () => const HomeRoute().go(context),
          ),
        ],
      ),
    );
  }
}
