import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/Profile/common_item_tile.dart';
import 'package:unicorn_flutter/View/Component/Parts/ai_announce_banner.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ChronicDiseaseView extends StatelessWidget {
  const ChronicDiseaseView({super.key});
// todo: 処理によってはあとでStatefulWidgetに変更
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    String disease = '偏頭痛';
    List<String> items = [
      'a',
      'a',
      'a',
      'a',
      'a',
      'a',
      'a',
      'a',
      'a',
      'a',
      'a',
    ];
    // todo: controller出来たら消す
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
                    Visibility(
                      visible: items.isNotEmpty,
                      child: IconButton(
                        onPressed: () {
                          const ProfileChronicDiseaseSearchRoute()
                              .push(context);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.blue,
                        ),
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
                // todo: AIチャット画面へ遷移
              },
            ),
            SizedBox(
              width: deviceWidth * 0.9,
              child: items.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: GestureDetector(
                        onTap: () {
                          const ProfileChronicDiseaseSearchRoute()
                              .push(context);
                          // todo: リマインダー画面へ
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
                    )
                  : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (items.isEmpty) {
                          return Container();
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            child: CommonItemTile(
                              title: disease,
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
                                        bodyText:
                                            Strings.DIALOG_BODY_TEXT_DELETE,
                                        onTap: () {
                                          // todo: お悩み削除処理
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
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
