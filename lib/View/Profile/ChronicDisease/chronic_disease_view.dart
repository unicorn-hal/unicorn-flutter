import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/ChronicDisease/chronic_disease_controller.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';
import 'package:unicorn_flutter/View/Component/Parts/image_banner.dart';
import 'package:unicorn_flutter/View/Component/Parts/register_content_tile.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

class ChronicDiseaseView extends StatefulWidget {
  const ChronicDiseaseView({super.key});

  @override
  State<ChronicDiseaseView> createState() => _ChronicDiseaseViewState();
}

class _ChronicDiseaseViewState extends State<ChronicDiseaseView> {
  late ChronicDiseaseController controller;
  @override
  void initState() {
    super.initState();
    controller = ChronicDiseaseController();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return CustomScaffold(
      body: SizedBox(
        height: deviceHeight,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ImageBanner(
              image: Assets.images.banner.aiTextChatBanner.image(),
              onTap: () {
                // AIチャット画面へ遷移
                const ProfileChronicDiseaseAiTextChatRoute().push(context);
              },
            ),
            const SpacerAndDivider(
              topHeight: 10,
              bottomHeight: 10,
            ),
            Expanded(
              child: SizedBox(
                width: deviceWidth,
                child: FutureBuilder<List<ChronicDisease>?>(
                  future: controller.getChronicDiseaseList(),
                  builder:
                      (context, AsyncSnapshot<List<ChronicDisease>?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: HeaderTitle(
                              title: '体のお悩み',
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: CustomLoadingAnimation(
                              text: Strings.LOADING_TEXT,
                              iconColor: Colors.grey,
                              textColor: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }
                    if (!snapshot.hasData) {
                      // todo: エラー時の処理
                      return const CustomText(text: 'エラーやん');
                    }
                    List<ChronicDisease> chronicDiseaseList = snapshot.data!;
                    if (chronicDiseaseList.isEmpty) {
                      return Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: HeaderTitle(
                              title: '体のお悩み',
                            ),
                          ),
                          RegisterContentTile(
                            tileText: 'お悩みを登録する',
                            onTap: () {
                              const ProfileChronicDiseaseSearchRoute()
                                  .push(context)
                                  .then((value) => setState(() {}));
                            },
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        SizedBox(
                          width: deviceWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                flex: 3,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: HeaderTitle(
                                    title: '体のお悩み',
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    ProfileChronicDiseaseSearchRoute(
                                      $extra: chronicDiseaseList,
                                    )
                                        .push(context)
                                        .then((value) => setState(() {}));
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: deviceWidth * 0.9,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: chronicDiseaseList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                  ),
                                  child: CommonItemTile(
                                    title:
                                        chronicDiseaseList[index].diseaseName,
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
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          builder: (_) {
                                            return CustomDialog(
                                              title:
                                                  Strings.DIALOG_TITLE_CAVEAT,
                                              bodyText: Strings
                                                  .DIALOG_BODY_TEXT_DELETE,
                                              rightButtonOnTap: () async {
                                                ProtectorNotifier()
                                                    .enableProtector();
                                                await controller
                                                    .deleteChronicDisease(
                                                        chronicDiseaseList[
                                                                index]
                                                            .chronicDiseaseId);
                                                ProtectorNotifier()
                                                    .disableProtector();
                                                setState(() {});
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
