import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Profile/ChronicDisease/chronic_disease_controller.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_loading_animation.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/ai_announce_banner.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

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
    return CustomScaffold(
      isScrollable: true,
      body: SizedBox(
        width: deviceWidth,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: SizedBox(
                width: deviceWidth * 0.9,
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomText(text: '体のお悩み'),
                    IconButton(
                      onPressed: () {
                        const ProfileChronicDiseaseSearchRoute().push(context);
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AiAnnounceBanner(
              title: Strings.AI_BANNER_TITLE_ASK,
              description: Strings.AI_BANNER_DESCRIPTION_ASK,
              bannerColor: ColorName.shadowGray,
              imageBackgroundColor: ColorName.mainColor,
              onTap: () {
                const ChatAiTextChatRoute().push(context);
                // todo: 後で引数とか入れるかも
              },
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              child: FutureBuilder<List<ChronicDisease>?>(
                future: controller.getChronicDiseaseList(),
                builder:
                    (context, AsyncSnapshot<List<ChronicDisease>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: CustomLoadingAnimation(
                        text: 'ローディング中',
                        iconColor: Colors.grey,
                        textColor: Colors.grey,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    // todo: エラー時の処理
                    return const CustomText(text: 'エラーやん');
                  }
                  List<ChronicDisease> chronicDiseaseList = snapshot.data!;
                  if (chronicDiseaseList.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          const ProfileChronicDiseaseSearchRoute()
                              .push(context);
                        },
                        child: DottedBorder(
                          dashPattern: const [15, 10],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(20),
                          child: SizedBox(
                            width: deviceWidth * 0.9,
                            height: 200,
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                                CustomText(
                                  text: 'お悩みを登録する',
                                  color: ColorName.textGray,
                                  fontSize: 14,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: chronicDiseaseList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                          ),
                          child: CommonItemTile(
                            title: chronicDiseaseList[index].diseaseName,
                            tileHeight: 60,
                            boxDecoration: BoxDecoration(
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
                                      title: Strings.DIALOG_TITLE_CAVEAT,
                                      bodyText: Strings.DIALOG_BODY_TEXT_DELETE,
                                      onTap: () async {
                                        ProtectorNotifier().enableProtector();
                                        await controller.deleteChronicDisease(
                                            chronicDiseaseList[index]
                                                .chronicDiseaseId);
                                        ProtectorNotifier().disableProtector();
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
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
