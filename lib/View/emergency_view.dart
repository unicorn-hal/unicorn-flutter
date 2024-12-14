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

class EmergencyView extends StatefulWidget {
  const EmergencyView({super.key});

  @override
  State<EmergencyView> createState() => _EmergencyViewState();
}

class _EmergencyViewState extends State<EmergencyView> {
  late EmergencyController controller;

  @override
  void initState() {
    super.initState();
    controller = EmergencyController(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return CustomScaffold(
      isAppbar: false,
      isScrollable: true,
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.2,
                width: size.width * 0.9,
                margin: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  border: Border.all(
                    color: Colors.red.shade700,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
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
                            text: 'Unicornを要請しています',
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
                valueListenable: controller.unicornSupport,
                builder: (context, value, _) {
                  if (value == null) {
                    return const SizedBox();
                  }
                  return SizedBox(
                    width: size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: '地図情報',
                          fontSize: 16,
                        ),
                        const Divider(),
                        SizedBox(
                          width: size.width * 0.9,
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.green.shade700,
                                size: 24,
                              ),
                              const CustomText(
                                text: 'Unicorn待機拠点: HAL東京',
                                fontSize: 14,
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
                                color: Colors.purpleAccent.shade700,
                                size: 24,
                              ),
                              ValueListenableBuilder(
                                valueListenable: controller.unicornSupport,
                                builder: (context, value, _) {
                                  if (value == null ||
                                      value.robotLatitude == null ||
                                      value.robotLongitude == null) {
                                    return const SizedBox();
                                  }
                                  return FutureBuilder(
                                    future: controller.getAddressFromLatLng(
                                        LatLng(value.robotLatitude!,
                                            value.robotLongitude!)),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Container();
                                      }
                                      return CustomText(
                                        text: snapshot.data.toString(),
                                        fontSize: 14,
                                      );
                                    },
                                  );
                                },
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
                                size: 24,
                              ),
                              FutureBuilder(
                                future: controller.getAddressFromLatLng(
                                  controller.userCurrentLocation!,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  }
                                  return CustomText(
                                    text: snapshot.data.toString(),
                                    fontSize: 14,
                                  );
                                },
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
                          child: (value.robotLatitude == null ||
                                  value.robotLongitude == null)
                              ? const SizedBox()
                              : GoogleMapViewer(
                                  point: controller.unicornStartPoint!,
                                  destination: controller.userCurrentLocation,
                                  current: LatLng(value.robotLatitude!,
                                      value.robotLongitude!),
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: controller.supportLog,
                builder: (context, value, _) {
                  return SizedBox(
                    width: size.width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'サポートログ',
                          fontSize: 16,
                        ),
                        const Divider(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return CustomText(
                              text: value[index],
                              fontSize: 12,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 30,
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
