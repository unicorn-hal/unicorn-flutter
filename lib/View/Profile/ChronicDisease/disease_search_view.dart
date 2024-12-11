import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/ChronicDisease/disease_search_controller.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Model/Entity/Disease/disease.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class DiseaseSearchView extends StatefulWidget {
  const DiseaseSearchView({
    super.key,
    this.chronicDiseaseList,
  });
  final List<ChronicDisease>? chronicDiseaseList;

  @override
  State<DiseaseSearchView> createState() => _DiseaseSearchViewState();
}

class _DiseaseSearchViewState extends State<DiseaseSearchView> {
  late DiseaseSearchController controller;
  final focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    controller = DiseaseSearchController(widget.chronicDiseaseList);
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double topPaddingHeight = MediaQuery.of(context).padding.top;

    return CustomScaffold(
      isScrollable: true,
      focusNode: focusNode,
      body: Container(
        constraints: BoxConstraints(
          minHeight: deviceHeight - appBarHeight - topPaddingHeight - 80,
          // todo: NavigationBarの高さをもらってくる予定
        ),
        width: deviceWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: HeaderTitle(
                    title: 'お悩みを追加する',
                    useBorder: false,
                  ),
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: CustomTextfield(
                    hintText: '病名を入力してください',
                    controller: controller.diseaseTextController,
                    height: 50,
                    maxLines: 1,
                    maxLength: 40,
                    width: deviceWidth * 0.9,
                    useSearchButton: true,
                    buttonOnTap: () async {
                      if (controller.checkEmpty()) {
                        return;
                      }
                      await controller.getDiseaseList();
                      setState(() {});
                    },
                  ),
                ),
                controller.diseaseList == null
                    // todo: エラー時の処理
                    ? SizedBox(
                        height: 180,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: deviceWidth * 0.9,
                            decoration: const BoxDecoration(
                              color: ColorName.profileBackgroundColor,
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: CustomText(
                                text: '通信エラー',
                              ),
                            ),
                          ),
                        ),
                      )
                    : controller.diseaseList!.isEmpty
                        ? SizedBox(
                            height: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                width: deviceWidth * 0.9,
                                decoration: const BoxDecoration(
                                  color: ColorName.profileBackgroundColor,
                                ),
                                child: !controller.isSearched
                                    ? const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.search,
                                          ),
                                          CustomText(
                                            text: 'お悩みを探す',
                                          )
                                        ],
                                      )
                                    : const Align(
                                        alignment: Alignment.center,
                                        child: CustomText(
                                          text: '検索結果がありません',
                                        ),
                                      ),
                              ),
                            ),
                          )
                        : SizedBox(
                            width: deviceWidth * 0.9,
                            child: Column(
                              children: [
                                const Align(
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
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: controller.diseaseList!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: CommonItemTile(
                                        title: controller
                                            .diseaseList![index].diseaseName,
                                        tileHeight: 60,
                                        boxDecoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        action: IconButton(
                                          onPressed: () async {
                                            await controller
                                                .registrationDisease(controller
                                                    .diseaseList![index]
                                                    .diseaseId);
                                            controller.setDiseaseList(index);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: deviceWidth,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: HeaderTitle(
                      title: 'よくあるお悩み',
                      useBorder: false,
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
                      child: FutureBuilder<List<Disease>?>(
                        future: controller.getFamousDiseaseList(),
                        builder:
                            (context, AsyncSnapshot<List<Disease>?> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: CustomLoadingAnimation(
                                text: Strings.LOADING_TEXT,
                                iconColor: Colors.grey,
                                textColor: Colors.grey,
                              ),
                            );
                          }
                          if (!snapshot.hasData) {
                            // todo: エラー時の処理
                            return const CustomText(text: 'エラーやん');
                          }
                          List<Disease> famousDiseaseList = snapshot.data!;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: famousDiseaseList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: CommonItemTile(
                                  title: famousDiseaseList[index].diseaseName,
                                  tileHeight: 60,
                                  boxDecoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  action: IconButton(
                                    onPressed: () async {
                                      if (controller.registrationCheck[index]) {
                                        return;
                                      }
                                      await controller.registrationDisease(
                                          famousDiseaseList[index].diseaseId);
                                      await controller
                                          .updateChronicDiseaseList();
                                      setState(() {});
                                    },
                                    icon: controller.registrationCheck[index]
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
                              );
                            },
                          );
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
