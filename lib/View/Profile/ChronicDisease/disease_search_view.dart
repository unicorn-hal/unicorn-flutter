import 'package:flutter/material.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class DiseaseSearchView extends StatefulWidget {
  const DiseaseSearchView({super.key});

  @override
  State<DiseaseSearchView> createState() => _DiseaseSearchViewState();
}

class _DiseaseSearchViewState extends State<DiseaseSearchView> {
  TextEditingController controller = TextEditingController();
  String disease = '偏頭痛';
  String regularDisease = '糖尿病';
  List<bool> items = [
    false,
    true,
    false,
    false,
    true,
    false,
    false,
    true,
    false,
  ];
  List<bool> regularItems = [
    false,
    true,
    false,
  ];
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double topPaddingHeight = MediaQuery.of(context).padding.top;

    return CustomScaffold(
      isScrollable: true,
      body: Container(
        constraints: BoxConstraints(
          minHeight: deviceHeight - appBarHeight - topPaddingHeight - 80,

          /// 画面の高さ - appBarの高さ - topPaddの高さ -　NavigationBarのデフォルト高さ = Viewで使用できる高さびたびた
        ),
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceWidth * 0.9,
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 20,
                        left: 5,
                      ),
                      child: CustomText(text: 'お悩みを追加する'),
                    ),
                  ),
                  CustomTextfield(
                    hintText: '病名を入力してください',
                    controller: controller,
                    height: 50,
                    maxLines: 1,
                    maxLength: 40,
                  ),
                  Visibility(
                    visible: items.isNotEmpty,
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 5,
                          left: 5,
                        ),
                        child: CustomText(
                          text: 'もしかして',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: items.isEmpty ? 0 : 350,

                    /// タイル1枚分 = 70
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (items.isEmpty) {
                          return Container();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                      ),
                                      child: CustomText(text: disease),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      onPressed: items[index]
                                          ? () {
                                              // todo: お悩み削除処理をつけるか、そもそも登録済み病気を表示しないか、見えるけど処理なしか悩み
                                            }
                                          : () {
                                              // todo: お悩み追加処理
                                            },
                                      icon: items[index]
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : const Icon(
                                              Icons.add,
                                              color: Colors.blue,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        bottom: 10,
                        left: 5,
                      ),
                      child: CustomText(text: 'よくあるお悩み'),
                    ),
                  ),
                ),
                Container(
                  width: deviceWidth,
                  height: 230,
                  decoration: const BoxDecoration(
                    color: ColorName.profileBackgroundColor,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: deviceWidth * 0.9,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: regularItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (regularItems.isEmpty) {
                            return Container();
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: CustomText(text: regularDisease),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        onPressed: regularItems[index]
                                            ? () {
                                                // todo: お悩み削除処理をつけるか、見えるけど処理なしか悩み。ここは常に決まった数表示したい
                                              }
                                            : () {
                                                // todo: お悩み追加処理
                                              },
                                        icon: regularItems[index]
                                            ? const Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              )
                                            : const Icon(
                                                Icons.add,
                                                color: Colors.blue,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
