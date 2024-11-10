import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/TextChat/doctor_text_chat_controller.dart';
import 'package:unicorn_flutter/Model/Data/Account/account_data.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/Chat/message_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class DoctorTextChatView extends StatefulWidget {
  DoctorTextChatView({super.key});

  @override
  State<DoctorTextChatView> createState() => _DoctorTextChatViewState();
}

class _DoctorTextChatViewState extends State<DoctorTextChatView> {
  late DoctorTextChatController controller;
  // todo: controllerを使ってチャット型のリストを作る
  final List<Map<String, bool>> chatList = [
    {
      '何してんですか': true,
    },
    {
      '何もしてないよ': false,
    },
    {
      '昨日のテレビ見ましたか？': true,
    },
    {
      'ずっと仕事だったわ': false,
    },
    {
      '普通に面白かったですよ': true,
    },
    {
      '病気だよお前': false,
    },
    {
      'マジか': true,
    },
    {
      'どんなの？': false,
    },
    {
      'ああああ': true,
    },
    {
      'あああああああ': false,
    },
    {
      '昨日のテレビ見ましたか？': true,
    },
    {
      'ずっと仕事だったわ': false,
    },
    {
      '普通に面白かったですよ': true,
    },
    {
      '病気だよお前': false,
    },
    {
      'マジか': true,
    },
    {
      'どんなの？': false,
    },
    {
      'ああああ': true,
    },
    {
      'あああああああ': false,
    },
  ];

  // 医師名
  final String doctorName = '長谷川';

  //　チャット用のコントローラー
  final TextEditingController chatController = TextEditingController();

  // フォーカス用のノード
  final focusNode = FocusNode();

  // スクロール用のコントローラー
  final ScrollController scrollController = ScrollController();

  // スクロール位置が最下部になるかどうかを判定するための変数
  bool scrollButton = false;

  @override
  void initState() {
    super.initState();
    controller = DoctorTextChatController('1234567890');

    //画面が表示された時にスクロール位置が最下部になるようにする
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    //スクロール位置が最下部になかったらscrollButtonを表示する
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent !=
          scrollController.position.pixels) {
        scrollButton = true;
        setState(() {});
      } else {
        scrollButton = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CustomScaffold(
      focusNode: focusNode,
      appBar: CustomAppBar(
        backgroundColor: ColorName.mainColor,
        title: '$doctorName先生',
        foregroundColor: Colors.white,
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
                ValueListenableBuilder<List<Message>>(
                    valueListenable: controller.messageHistory,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: value.length,
                              controller: scrollController,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                final Message message = value[index];
                                return MessageTile(
                                  messageBody: message.content,
                                  // 自分のメッセージかどうかを判定
                                  myMessage: message.senderId ==
                                      AccountData().account!.uid,
                                  postAt: DateFormat('HH:MM')
                                      .format(message.sentAt),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                        ],
                      );
                    }),
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: Visibility(
                    visible: scrollButton,
                    child: GestureDetector(
                      //アニメーションをつけてスクロール位置を最下部にする
                      onTap: () {
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.bounceIn);
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
                      controller: chatController,
                      width: size.width * 0.85,
                      height: 44,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // todo: チャットを送信するAPIを叩く
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
          )
        ],
      ),
    );
  }
}
