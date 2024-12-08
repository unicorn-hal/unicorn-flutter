import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Controller/Chat/chat_top_controller.dart';
import 'package:unicorn_flutter/Model/Chat/chat_data.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_info_tile.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class ChatTopView extends StatelessWidget {
  const ChatTopView({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    ChatTopController controller = ChatTopController();
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        CustomScaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // AIチャット画面へ遷移
                    const ChatAiTextChatRoute().push(context);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: ColorName.shadowGray,
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ]),
                    child: Assets.images.banner.aiTextChatBanner.image(),
                  ),
                ),
              ),

              const SpacerAndDivider(
                topHeight: 10,
                bottomHeight: 10,
              ),

              /// やりとり履歴表示部
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'やりとりしたことある先生',
                    fontSize: 18,
                  ),
                ),
              ),
              Consumer(builder: (context, ref, _) {
                ChatData chatData = ref.watch(chatDataProvider);
                if (chatData.data.isEmpty) {
                  // チャット履歴がない場合は履歴がありませんを表示
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: SizedBox(
                      width: size.width * 0.9,
                      height: 400,
                      child: const Center(
                        child: CustomText(
                          text: 'やりとりした先生がいません',
                        ),
                      ),
                    ),
                  );
                }
                // チャット履歴がある場合はリスト表示
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                    ),
                    child: SizedBox(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: chatData.data.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    UserInfoTile(
                                      onTap: () {
                                        ChatDoctorInformationRoute(
                                          chatData.data[index].doctor.doctorId,
                                        ).push(context);
                                      },
                                      userName: chatData
                                              .data[index].doctor.lastName +
                                          chatData.data[index].doctor.firstName,
                                      description:
                                          '${chatData.data[index].latestMessageText}',
                                      imageUrl: chatData
                                          .data[index].doctor.doctorIconUrl,
                                    ),
                                    if (index == chatData.data.length - 1)
                                      const SizedBox(
                                        height: 60,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),

        /// 医師を探すボタン
        Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                // 医師検索画面へ遷移
                ChatDoctorSearchRoute().push(context);
              },
              child: Container(
                width: 160,
                height: 50,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: ColorName.shadowGray,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: ColorName.mainColor,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                    CustomText(
                      text: '医師を探す',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
