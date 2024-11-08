import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/Search/doctor_search_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Department/department.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dropdown.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_info_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class DoctorSearchView extends StatefulWidget {
  const DoctorSearchView({super.key});

  @override
  State<DoctorSearchView> createState() => _DoctorSearchViewState();
}

class _DoctorSearchViewState extends State<DoctorSearchView> {
  late DoctorSearchController controller;

  @override
  void initState() {
    super.initState();
    controller = DoctorSearchController();
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
          Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CustomText(text: '検索結果'),
                ),
              ),
              StreamBuilder<List<Doctor>>(
                  stream: controller.doctorListStream,
                  builder: (context, snapshot) {
                    if (snapshot.data?.isEmpty ?? true) {
                      return const Center(
                        child: SizedBox(
                          width: 300,
                          height: 300,
                          child: Center(
                            child: CustomText(text: '該当する医師が見つかりませんでした'),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
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
                                ChatDoctorInformationRoute(
                                        snapshot.data![index].doctorId)
                                    .push(context);
                              },
                              userName: snapshot.data![index].firstName +
                                  snapshot.data![index].lastName,
                              description:
                                  '病院: ${snapshot.data![index].hospital.hospitalName} 診療科: ${snapshot.data![index].departments.map((e) => e.departmentName).join(',')}',
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
