import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Chat/chat_top_controller.dart';
import 'package:unicorn_flutter/Model/Chat/chat_data.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/ai_announce_banner.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_info_tile.dart';
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
          isScrollable: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// AIアナウンスバナー表示部
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: 'AIチャット',
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: SizedBox(
                  width: size.width * 0.9,
                  child: AiAnnounceBanner(
                    title: Strings.AI_BANNER_TITLE_HEALTHCHECK,
                    description: Strings.AI_BANNER_DESCRIPTION_HEALTHCHECK,
                    bannerColor: ColorName.shadowGray,
                    imageBackgroundColor: ColorName.mainColor,
                    onTap: () {
                      // todo: AIチャット画面へ遷移
                      ChatAiTextChatRoute().push(context);
                    },
                  ),
                ),
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
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  width: size.width,
                  constraints: const BoxConstraints(
                    minHeight: 400,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: chatData.data.length,
                    itemBuilder: (context, index) {
                      return UserInfoTile(
                        onTap: () {
                          // todo: それぞれのチャット画面へ遷移
                          ChatDoctorInformationRoute(
                            chatData.data[index].doctor.doctorId,
                          ).push(context);
                        },
                        userName: chatData.data[index].doctor.lastName +
                            chatData.data[index].doctor.firstName,
                        description:
                            '${chatData.data[index].latestMessageText}',
                        imageUrl: chatData.data[index].doctor.doctorIconUrl,
                      );
                    },
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
          child: CircleButton(
            buttonSize: 80,
            buttonColor: ColorName.mainColor,
            onTap: () {
              // todo: 医師を探す画面へ遷移
              const ChatDoctorSearchRoute().push(context);
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
