import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/doctor_search_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Department/department.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dropdown.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_info_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class DoctorSearchView extends StatefulWidget {
  DoctorSearchView({super.key});

  @override
  State<DoctorSearchView> createState() => _DoctorSearchViewState();
}

class _DoctorSearchViewState extends State<DoctorSearchView> {
  late DoctorSearchController controller;

  final focusNode = FocusNode();

  // 仮で医師リストをStringで作成
  final List<String> doctors = [
    // '医師1',
    // '医師2',
    // '医師3',
    // '医師4',
    // '医師5',
    // '医師6',
    // '医師7',
    // '医師8',
    // '医師9',
    // '医師10',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = DoctorSearchController();
  }

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
                      child: CustomText(
                        text: '病院名 :',
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
                      child: CustomText(
                        text: '診療科 :',
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
                          for (Department department
                              in controller.departmentList)
                            DropdownMenuItem(
                              value:
                                  controller.departmentList.indexOf(department),
                              child: CustomText(
                                text: department.departmentName,
                                fontSize: 12,
                              ),
                            ),
                        ],
                        onChanged: (int? value) {
                          controller.setSelectedDepartmentIndex(value!);
                          setState(() {});
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
                      child: CustomText(
                        text: '医師名 :',
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

          const SpacerAndDivider(
            topHeight: 4.0,
            bottomHeight: 0,
          ),

          ///検索結果表示部
          if (controller.doctorList.isEmpty)
            // 医師リストが空の場合は該当する医師が見つかりませんでしたを表示
            SizedBox(
              width: size.width * 0.9,
              height: 400,
              child: const Center(
                child: CustomText(
                  text: '該当する医師が見つかりませんでした',
                ),
              ),
            )
          else
            // 医師リストがある場合は医師リストを表示
            Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CustomText(text: '検索結果'),
                  ),
                ),
                ListView.builder(
                    itemCount: controller.doctorList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 1.0,
                        ),
                        child: UserInfoTile(
                          tileColor: ColorName.userInfoTileBackground,
                          onTap: () {
                            // todo: 医師詳細画面へ遷移
                          },
                          userName: controller.doctorList[index].firstName +
                              controller.doctorList[index].lastName,
                          description:
                              '診療科: ${controller.doctorList[index].departments.map((e) => e.departmentName).join(',')}',
                        ),
                      );
                    }),
              ],
            ),
        ],
      ),
    );
  }
}
