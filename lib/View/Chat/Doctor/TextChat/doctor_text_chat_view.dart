import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/TextChat/doctor_text_chat_controller.dart';
import 'package:unicorn_flutter/Model/Data/Account/account_data.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/Chat/message_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

import '../../../../Model/Entity/Doctor/doctor.dart';

class DoctorTextChatView extends StatefulWidget {
  const DoctorTextChatView({
    super.key,
    required this.doctor,
    this.reserveMessage,
  });

  final Doctor doctor;
  final String? reserveMessage;
  @override
  State<DoctorTextChatView> createState() => _DoctorTextChatViewState();
}

class _DoctorTextChatViewState extends State<DoctorTextChatView> {
  late DoctorTextChatController controller;

  // フォーカス用のノード
  final focusNode = FocusNode();

  // スクロール位置が最下部になるかどうかを判定するための変数
  bool scrollButton = false;

  @override
  void initState() {
    super.initState();

    // doctorIdを元にチャットコントローラーを初期化
    controller = DoctorTextChatController(widget.doctor, widget.reserveMessage);

    //スクロール位置が最下部になかったらscrollButtonを表示する
    controller.scrollController.addListener(() {
      if (controller.scrollController.offset ==
          controller.scrollController.position.maxScrollExtent) {
        scrollButton = false;
      } else {
        scrollButton = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      focusNode: focusNode,
      appBar: CustomAppBar(
        backgroundColor: ColorName.mainColor,
        title: '${widget.doctor.lastName}${widget.doctor.firstName}先生',
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomText(
                  text: 'チャットサポート時間',
                  fontSize: 14,
                  color: Colors.white,
                ),
                CustomText(
                  text: widget.doctor.chatSupportHours,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ///背景画像を表示する
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: size.width,
                  color: Colors.blueAccent.shade100,
                ),
              ),
            ],
          ),

          ///チャット表示部
          SizedBox(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    children: [
                      ValueListenableBuilder<List<Message>>(
                          valueListenable: controller.messageHistory,
                          builder: (context, value, child) {
                            return ListView.builder(
                              itemCount: value.length,
                              shrinkWrap: true,
                              reverse: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 60),
                              itemBuilder: (BuildContext context, int index) {
                                final Message message = value[index];

                                return MessageTile(
                                  messageBody: message.content,
                                  // 自分のメッセージかどうかを判定
                                  myMessage: message.senderId ==
                                      AccountData().account!.uid,
                                  // utc時間を日本時間に変換
                                  postAt: DateFormat('HH:mm').format(
                                    message.sentAt.toLocal(),
                                  ),
                                  onLongPress: () async {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoActionSheet(
                                            actions: [
                                              message.senderId ==
                                                      AccountData().account!.uid
                                                  ? CupertinoActionSheetAction(
                                                      child: const CustomText(
                                                        text: 'メッセージを削除',
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () async {
                                                        // 自分のメッセージを削除する
                                                        Navigator.pop(context);

                                                        await controller
                                                            .deleteMessage(
                                                                message);
                                                      },
                                                    )
                                                  : CupertinoActionSheetAction(
                                                      child: const CustomText(
                                                        text: '通報',
                                                        color: Colors.red,
                                                      ),
                                                      onPressed: () async {
                                                        // 相手のメッセージを通報する
                                                        Navigator.pop(context);
                                                        await controller
                                                            .reportMessage(
                                                                message);
                                                      },
                                                    ),
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                              child: const CustomText(
                                                  text: 'キャンセル'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          );
                                        });
                                  },
                                );
                              },
                            );
                          }),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: Visibility(
                    visible: scrollButton,
                    child: GestureDetector(
                      //アニメーションをつけてスクロール位置を最下部にする
                      onTap: () {
                        if (controller.scrollController.hasClients) {
                          controller.scrollController.jumpTo(
                            controller
                                .scrollController.position.maxScrollExtent,
                          );
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ColorName.shadowGray,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_downward,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///チャット入力部,
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size.width,
              color: Colors.white,
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
                      controller: controller.chatController,
                      width: size.width * 0.85,
                      height: 44,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // todo: チャットを送信するAPIを叩く
                      await controller.sendMessage();
                    },
                    child: SizedBox(
                      width: size.width * 0.1,
                      height: 44,
                      child: const Icon(
                        Icons.send,
                        color: ColorName.subColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
