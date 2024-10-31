import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';
import 'package:unicorn_flutter/gen/assets.gen.dart';

import '../../../gen/colors.gen.dart';
import '../../Component/CustomWidget/custom_appbar.dart';
import '../../Component/CustomWidget/custom_text.dart';
import '../../Component/CustomWidget/custom_textfield.dart';
import '../../Component/Parts/Chat/message_tile.dart';

class AiChatView extends StatefulWidget {
  const AiChatView({super.key});

  @override
  State<AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<AiChatView> {
  final List<Map<String, bool>> chatList = [
    {
      'ああああ': true,
    },
    {
      'あああああああ': false,
    },
  ];

  //　チャット用のコントローラー
  final TextEditingController controller = TextEditingController();

  // フォーカス用のノード
  final focusNode = FocusNode();

  // スクロール位置が最下部になるかどうかを判定するための変数
  bool scrollButton = false;

  @override
  void initState() {
    super.initState();
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
                    SizedBox(
                        height: 140,
                        width: size.width,
                        child: Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: ColorName.mainColor,
                            backgroundImage: AssetImage(
                              Assets.images.icons.aiIcon.path,
                            ),
                          ),
                        )),
                    Expanded(
                      child: ListView.builder(
                        itemCount: chatList.isEmpty ? 1 : chatList.length,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          // todo: モデルに変更して当てはめる
                          // chatListが空のときはAIからのメッセージ
                          if (chatList.isEmpty) {
                            return SizedBox(
                              height: size.width * 0.1,
                              child: const Center(
                                child: CustomText(
                                  text: 'なんでも聞いてください！',
                                  fontSize: 18,
                                ),
                              ),
                            );
                          } else {
                            return MessageTile(
                                messageBody: chatList[index].keys.first,
                                myMessage: chatList[index].values.first,
                                postAt: '12:00');
                          }
                        },
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

          ///チャット入力部,テンプレボタン
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
                      onTap: () {
                        // todo: テンプレートボタンを押した時の処理
                        showDialog(
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
                                        // todo: 最終的にクイックアクションの数と内容を変更する
                                        child: ListView.builder(
                                          itemCount: 5,
                                          itemBuilder: (context, index) {
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
                                                    text: 'クイックアクション$indexについて',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                // todo: タップしたときの処理
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
                          controller: controller,
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
