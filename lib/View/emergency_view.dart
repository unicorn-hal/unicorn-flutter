import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unicorn_flutter/Controller/emergency_controller.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/blinking_widget.dart';
import 'package:unicorn_flutter/View/Component/Parts/google_map_viewer.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class EmergencyView extends StatelessWidget {
  const EmergencyView({super.key});

  // todo: Controllerから取得する
  final String startPointText = 'ユニコーン病院';
  final String destinationPointText = '東京都西新宿1-1-100';
  final LatLng startPoint = const LatLng(35.681236, 139.767125); // 東京駅
  final LatLng destinationPoint = const LatLng(35.690921, 139.700258); // 新宿駅

  @override
  Widget build(BuildContext context) {
    EmergencyController controller = EmergencyController();

    Size size = MediaQuery.of(context).size;

    return CustomScaffold(
      isAppbar: false,
      isScrollable: true,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.2,
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  border: Border.all(
                    color: Colors.red.shade700,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.red.shade700,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        BlinkingWidget(
                          duration: const Duration(milliseconds: 1000),
                          child: CustomText(
                            text: 'ユニコーンを要請しています',
                            color: Colors.red.shade700,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const CustomText(
                      text: '身体を安静にして到着をお待ちください',
                      color: ColorName.textBlack,
                      fontSize: 12,
                    ),
                    SizedBox(
                      width: size.width * 0.8,
                      child: const SpacerAndDivider(
                        topHeight: 16,
                        bottomHeight: 8,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.hexagonDots(
                          color: Colors.blue.shade700,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        CustomText(
                          text: '体温・血圧・心拍数を送信中',
                          color: Colors.blue.shade700,
                          fontSize: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: controller.supportLog,
                builder: (context, value, _) {
                  return SizedBox(
                    height: size.height * 0.2,
                    width: size.width * 0.9,
                    child: Column(
                      children: [
                        const CustomText(
                          text: 'サポートログ',
                          fontSize: 16,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              return CustomText(
                                text: value[index],
                                fontSize: 12,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: controller.useMap,
                builder: (context, value, _) {
                  if (!value) {
                    return const SizedBox();
                  }
                  return SizedBox(
                    height: size.height * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width * 0.9,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.green.shade700,
                                size: 30,
                              ),
                              CustomText(
                                text: startPointText,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.9,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.red.shade700,
                                size: 30,
                              ),
                              CustomText(
                                text: destinationPointText,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                        const SpacerAndDivider(
                          topHeight: 0,
                          bottomHeight: 10,
                        ),
                        Container(
                          height: size.height * 0.4,
                          width: size.width * 0.95,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: GoogleMapViewer(
                            point: startPoint,
                            destination: destinationPoint,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
