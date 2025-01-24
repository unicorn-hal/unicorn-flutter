import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Controller/Chat/chat_top_controller.dart';
import 'package:unicorn_flutter/Model/Cache/Doctor/PrimaryDoctors/primary_doctors_cache.dart';
import 'package:unicorn_flutter/Model/Data/Chat/chat_data.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/header_title.dart';
import 'package:unicorn_flutter/View/Component/Parts/image_banner.dart';
import 'package:unicorn_flutter/View/Component/Parts/user_info_tile.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../Model/Entity/Chat/chat.dart';

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
              ImageBanner(
                image: Assets.images.banner.aiTextChatBanner.image(),
                onTap: () {
                  // AIチャット画面へ遷移
                  const ChatAiTextChatRoute().push(context);
                },
              ),

              const SpacerAndDivider(
                topHeight: 10,
                bottomHeight: 10,
              ),

              /// やりとり履歴表示部
              const Align(
                alignment: Alignment.centerLeft,
                child: HeaderTitle(
                  title: 'やりとりしたことがある先生',
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  ChatData chatData = ref.watch(chatDataProvider);
                  if (chatData.data.isEmpty) {
                    // チャット履歴がない場合は履歴がありませんを表示
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        child: SizedBox(
                          width: size.width * 0.9,
                          child: const Center(
                            child: CustomText(
                              text: 'やりとりした先生がいません',
                            ),
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
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: chatData.data.length,
                              itemBuilder: (context, index) {
                                final Chat data = chatData.data[index];
                                return Column(
                                  children: [
                                    UserInfoTile(
                                      onTap: () {
                                        ChatDoctorInformationRoute(
                                          data.doctor.doctorId,
                                        ).push(context);
                                      },
                                      userName: data.doctor.lastName +
                                          data.doctor.firstName,
                                      description: '${data.latestMessageText}',
                                      imageUrl: data.doctor.doctorIconUrl,
                                      badge: PrimaryDoctorsCache()
                                              .isPrimaryDoctor(
                                                  data.doctor.doctorId)
                                          ? Assets
                                              .images.icons.primaryDoctorIcon
                                              .image(
                                              fit: BoxFit.cover,
                                            )
                                          : null,
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
                  );
                },
              ),
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
                color: ColorName.subColor,
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
          ),
        ),
      ],
    );
  }
}
