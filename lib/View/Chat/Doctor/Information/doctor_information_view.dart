import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/Information/doctor_information_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_indicator.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_image_circle.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../../Component/Parts/Chat/department_badges.dart';

class DoctorInformationView extends StatefulWidget {
  const DoctorInformationView({
    super.key,
    required this.doctorId,
  });

  final String doctorId;

  @override
  State<DoctorInformationView> createState() => _DoctorInformationViewState();
}

class _DoctorInformationViewState extends State<DoctorInformationView> {
  @override
  Widget build(BuildContext context) {
    DoctorInformationController controller =
        DoctorInformationController(widget.doctorId);
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      appBar: CustomAppBar(
        title: '医師情報',
        foregroundColor: Colors.white,
        backgroundColor: ColorName.mainColor,
        actions: [
          GestureDetector(
            onTap: () async {
              controller.primary
                  ? await controller.deletePrimaryDoctor()
                  : await controller.postPrimaryDoctor();
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
              ),
              child: Row(
                children: [
                  Icon(
                    controller.primary
                        ? Icons.verified_sharp
                        : Icons.verified_outlined,
                    color: controller.primary ? Colors.yellow : Colors.white,
                  ),
                  const SizedBox(width: 4),
                  CustomText(
                    text: controller.primary ? '主治医解除' : '主治医登録',
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      isScrollable: true,
      body: FutureBuilder<Doctor?>(
        future: controller.exist
            ? controller.getDoctorFromCache()
            : controller.getDoctor(),
        builder: (context, snapshot) {
          // データ取得中のローディングを表示
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: const Center(child: CustomIndicator()),
            );
          }
          if (!snapshot.hasData) {
            // todo: エラーが発生した場合、アプリを操作させない実装をする
            return const CustomText(text: 'エラーが発生しました');
          }
          // 表示するデータ
          final Doctor doctor = snapshot.data!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),

                /// 医師画像表示部
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 200,
                    child: UserImageCircle(
                      imageSize: 200,
                      imageUrl: doctor.doctorIconUrl,
                    ),
                  ),
                ),

                /// 医師名・科目表示部
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    children: [
                      controller.primary
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: 30,
                                height: 30,
                                child: Assets.images.icons.primaryDoctorIcon
                                    .image(),
                              ),
                            )
                          : const SizedBox(),
                      CustomText(
                        text: doctor.lastName + doctor.firstName,
                        fontSize: 26,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      const CustomText(
                        text: '先生',
                        fontSize: 20,
                      ),
                    ],
                  ),
                ),

                /// 通話予約&チャット画面へ遷移するボタン
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          ChatDoctorTextChatRoute($extra: doctor).push(context);
                        },
                        child: Container(
                          width: 160,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorName.shadowGray,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat,
                                color: ColorName.mainColor,
                                size: 40,
                              ),
                              CustomText(
                                text: 'チャット',
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          ChatDoctorVoiceCallReserveRoute(doctor).push(context);
                        },
                        child: Container(
                          width: 160,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorName.shadowGray,
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.call,
                                color: ColorName.mainColor,
                                size: 40,
                              ),
                              CustomText(
                                text: '通話予約',
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: SpacerAndDivider(),
                ),

                /// 医師情報表示部
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: HeaderTitle(
                      title: 'この医師について',
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.9,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: ColorName.shadowGray,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: CustomText(
                          text: '対応可能時間',
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: CustomText(
                            text: 'チャット: ${doctor.chatSupportHours}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: CustomText(
                          text: '通話: ${doctor.callSupportHours}',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
