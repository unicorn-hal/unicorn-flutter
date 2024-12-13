import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/Information/doctor_information_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_indicator.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
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
      actions: [
        ValueListenableBuilder(
            valueListenable: controller.primary,
            builder: (context, value, child) {
              return GestureDetector(
                onTap: () async {
                  if (value) {
                    await controller.deletePrimaryDoctors();
                  } else {
                    await controller.postPrimaryDoctors();
                  }
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: CustomText(
                    text: value ? '主治医登録を解除' : '主治医登録する',
                    color: Colors.white,
                  ),
                ),
              );
            }),
      ],
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
            child: Stack(
              children: [
                Column(
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
                    SizedBox(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomText(
                            text: doctor.lastName + doctor.firstName,
                            fontSize: 26,
                          ),
                          const CustomText(
                            text: '先生',
                            fontSize: 20,
                          ),
                        ],
                      ),
                    ),

                    /// 科目カード表示部
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 10,
                        ),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final department in doctor.departments)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    ChatDoctorSearchRoute(
                                      departmentId: department.departmentId,
                                    ).pushReplacement(context);
                                  },
                                  child: DepartmentBadge(
                                    name: department.departmentName,
                                  ),
                                ),
                              ),
                          ],
                        ),
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
                              ChatDoctorTextChatRoute($extra: doctor)
                                  .push(context);
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
                              ChatDoctorVoiceCallReserveRoute(doctor)
                                  .push(context);
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
                        child: CustomText(
                          text: 'この医師について',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.9,
                      height: 140,
                      decoration: BoxDecoration(
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
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 60,
                    height: 60,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: controller.isPrimaryDoctor(doctor.doctorId)
                        ? Assets.images.icons.primaryDoctorIcon
                            .image(fit: BoxFit.cover)
                        : Assets.images.icons.normalDoctorIcon
                            .image(fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
