import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  //todo: controllerに移植
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController departmentNameController =
      TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();

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

  //todo: depertmentsのindex
  int? selectedItem = 0;
  // 仮で診療科リストをStringで作成
  final List<String> departments = [
    '診療科1',
    '診療科2',
    '診療科3',
    '診療科4',
    '診療科5',
    '診療科6',
    '診療科7',
    '診療科8',
    '診療科9',
    '診療科10',
  ];

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
                      controller: hospitalNameController,
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
                  width: size.width * 0.5,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 4.0),
                      child: CustomDropdown(
                        height: 44,
                        dropdownItems: [
                          // todo: controllerからforの個数決める
                          for (String department in departments)
                            DropdownMenuItem(
                              value: departments.indexOf(department),
                              child: CustomText(
                                text: department,
                                fontSize: 12,
                              ),
                            ),
                        ],
                        onChanged: (int? value) {
                          setState(() {
                            selectedItem = value;
                          });
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
                        controller: doctorNameController,
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
          doctors.isEmpty
              ?
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
              :
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
                        itemCount: doctors.length,
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
                              userName: doctors[index],
                              description: '診療科: 内科',
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
