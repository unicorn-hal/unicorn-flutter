import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/Search/doctor_search_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Department/department.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dropdown.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_indicator.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';

import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../../../Route/router.dart';
import '../../../Component/Parts/user_info_tile.dart';

class DoctorSearchView extends StatefulWidget {
  const DoctorSearchView({super.key, this.departmentId});

  final String? departmentId;

  @override
  State<DoctorSearchView> createState() => _DoctorSearchViewState();
}

class _DoctorSearchViewState extends State<DoctorSearchView> {
  late DoctorSearchController controller;

  @override
  void initState() {
    super.initState();
    controller = DoctorSearchController(departmentId: widget.departmentId);
  }

  @override
  void dispose() {
    super.dispose();
    // Viewが破棄される際にControllerにあるリスナーをdisposeする
    controller.doctorNameController.dispose();
    controller.hospitalNameController.dispose();
  }

  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return CustomScaffold(
      isScrollable: true,
      focusNode: focusNode,
      appBar: CustomAppBar(
        title: '医師を探す',
        foregroundColor: Colors.white,
        backgroundColor: ColorName.mainColor,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 4.0,
          ),

          /// 検索内容入力部
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: 54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.25,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.apartment,
                                  color: ColorName.mainColor,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: CustomText(
                                    text: '病院名',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.75,
                        child: Center(
                          child: CustomTextfield(
                            width: size.width * 0.7,
                            height: 44,
                            hintText: '病院名を入力してください',
                            controller: controller.hospitalNameController,
                            maxLength: 20,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: 54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.25,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.healing,
                                  color: ColorName.mainColor,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: CustomText(
                                    text: '診察科',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.6,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 4.0),
                            child: CustomDropdown(
                              height: 44,
                              dropdownItems: [
                                // 未選択だけはnullをセット
                                const DropdownMenuItem(
                                  value: null,
                                  child: CustomText(
                                    text: '未選択',
                                    fontSize: 12,
                                  ),
                                ),
                                for (Department department
                                    in controller.departmentList)
                                  DropdownMenuItem(
                                    value: controller.departmentList
                                        .indexOf(department),
                                    child: CustomText(
                                      text: department.departmentName,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                              selectIndex: controller.selectedDepartmentIndex,
                              onChanged: (int? value) {
                                // valueをセット。"未選択"の場合はnullが入る
                                controller.chaneDepartqmentIndex(value);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: 54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width * 0.25,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.face,
                                  color: ColorName.mainColor,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: CustomText(
                                    text: '医師名',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.75,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: CustomTextfield(
                              width: size.width * 0.6,
                              height: 44,
                              hintText: '名前を入力してください',
                              controller: controller.doctorNameController,
                              maxLength: 10,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 36,
              width: size.width * 0.9,
              child: CustomButton(
                text: '検索',
                onTap: () {
                  setState(() {});
                },
                isFilledColor: true,
              ),
            ),
          ),

          const SpacerAndDivider(
            topHeight: 4.0,
            bottomHeight: 0,
          ),

          ///検索結果表示部
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: HeaderTitle(
                    title: '検索結果',
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              FutureBuilder<List<Doctor>>(
                  future: controller.searchDoctors(),
                  builder: (context, snapshot) {
                    // 通信中はローディングを表示
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const SizedBox(
                        width: 300,
                        height: 300,
                        child: Center(
                          child: CustomIndicator(),
                        ),
                      );
                    }
                    // 通信失敗＆データがない場合は文字を表示
                    if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const SizedBox(
                        width: 300,
                        height: 300,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 40,
                                color: ColorName.mainColor,
                              ),
                              CustomText(text: '該当する医師が見つかりませんでした'),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final Doctor doctor = snapshot.data![index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                              vertical: 1.0,
                            ),
                            child: UserInfoTile(
                              tileColor: ColorName.userInfoTileBackground,
                              onTap: () {
                                ChatDoctorInformationRoute(doctor.doctorId)
                                    .push(context);
                              },
                              userName: doctor.lastName + doctor.firstName,
                              description:
                                  '病院: ${doctor.hospital.hospitalName} 診療科: ${doctor.departments.map((e) => e.departmentName).join(',')}',
                              imageUrl: doctor.doctorIconUrl,
                            ),
                          );
                        });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
