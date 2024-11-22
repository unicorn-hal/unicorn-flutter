import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/chatgpt_role.dart';
import 'package:unicorn_flutter/Controller/Chat/Ai/TextChat/ai_text_chat_controller.dart';
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_chat.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_indicator.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/spacer_and_divider.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

import '../../../../gen/colors.gen.dart';
import '../../../Component/CustomWidget/custom_appbar.dart';
import '../../../Component/CustomWidget/custom_text.dart';
import '../../../Component/CustomWidget/custom_textfield.dart';
import '../../../Component/Parts/Chat/message_tile.dart';

class AiTextChatView extends StatefulWidget {
  const AiTextChatView({super.key});

  @override
  State<AiTextChatView> createState() => _AiTextChatViewState();
}

class _AiTextChatViewState extends State<AiTextChatView> {
  late AiTextChatController controller;

  // フォーカス用のノード
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = AiTextChatController();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      focusNode: focusNode,
      appBar: CustomAppBar(
        backgroundColor: ColorName.mainColor,
        title: 'AIチャット',
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ///背景画像を表示する
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(width: size.width, color: Colors.white),
              ),
            ],
          ),

          ///チャット表示部
          SizedBox(
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 80,
                        width: size.width,
                        child: Center(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: ColorName.mainColor,
                            backgroundImage: AssetImage(
                              Assets.images.icons.uniIcon.path,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Container(
                        height: 60,
                        width: size.width * 0.9,
                        decoration: const BoxDecoration(
                          color: ColorName.shadowGray,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: const Center(
                          child: CustomText(
                            text:
                                '『頭痛や腹痛に詳しい先生を紹介して』\n『おくすりのリマインダー登録をして』\nこのように気軽に話しかけてみましょう！',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SpacerAndDivider(
                      topHeight: 4,
                      bottomHeight: 4,
                    ),
                    controller.chatList.value.isNotEmpty
                        // メッセージがあるときは表示
                        ? Expanded(
                            child: ValueListenableBuilder<List<ChatGPTChat>>(
                                valueListenable: controller.chatList,
                                builder: (context, value, child) {
                                  return SingleChildScrollView(
                                    controller: controller.scrollController,
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          itemCount: value.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final ChatGPTChat chat =
                                                value[index];
                                            // システムメッセージは表示しない
                                            if (chat.message.role ==
                                                ChatGPTRole.system) {
                                              return Container();
                                            }

                                            return MessageTile(
                                              messageBody: chat.message.content,
                                              myMessage: chat.message.role ==
                                                  ChatGPTRole.user,
                                              postAt: DateFormat('HH:mm')
                                                  .format(chat.created),
                                              postAtColor: Colors.black,
                                            );
                                          },
                                        ),
                                        controller.isThinking
                                            ? MessageTile(
                                                actionWidget: SizedBox(
                                                  width: size.width * 0.5,
                                                  height: 50,
                                                  child: const FittedBox(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: CustomIndicator(),
                                                    ),
                                                  ),
                                                ),
                                                myMessage: false,
                                                postAt: '')
                                            : Container(),
                                        const SizedBox(
                                          height: 200,
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          )
                        // メッセージがないときはAIからのメッセージを表示
                        : SizedBox(
                            width: size.width,
                            height: 50,
                            child: const Center(
                              child: CustomText(
                                text: '何でも聞いて下さい！',
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ],
            ),
          ),

          ///チャット入力部,クイックアクションボタン
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircleButton(
                      buttonSize: 60,
                      buttonColor: ColorName.mainColor,
                      onTap: () async {
                        final action = await showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                clipBehavior: Clip.antiAlias,
                                insetPadding: EdgeInsets.zero,
                                surfaceTintColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: SizedBox(
                                  width: 250,
                                  height: 300,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 250,
                                        height: 50,
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        child: const Center(
                                          child: CustomText(text: 'クイックアクション'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 250,
                                        height: 250,
                                        child: ListView.builder(
                                          itemCount:
                                              controller.quickActionList.length,
                                          itemBuilder: (context, index) {
                                            final String action = controller
                                                .quickActionList[index];
                                            return ListTile(
                                              contentPadding: EdgeInsets.zero,
                                              title: Container(
                                                width: 250,
                                                height: 40,
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          ColorName.shadowGray,
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: CustomText(
                                                    text: action,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(
                                                  context,
                                                  action,
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });

                        // ダイアログの返り値を待って処理を行う
                        if (action != null) {
                          await controller.postMessage(action);
                        }
                      },
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: size.width,
                  color: ColorName.shadowGray,
                  constraints: const BoxConstraints(
                    minHeight: 60,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                        child: CustomTextfield(
                          hintText: 'メッセージを入力',
                          controller: controller.messageController,
                          width: size.width * 0.85,
                          height: 44,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // メッセージを送信する際はスクロールを一番下に移動
                          controller.scrollController.jumpTo(controller
                              .scrollController.position.maxScrollExtent);
                          await controller.postMessage();
                        },
                        child: SizedBox(
                          width: size.width * 0.1,
                          height: 44,
                          child: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
