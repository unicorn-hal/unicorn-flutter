import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/Chat/message_tile.dart';
import 'package:unicorn_flutter/gen/colors.gen.dart';

class DoctorChatView extends StatefulWidget {
  DoctorChatView({super.key});

  @override
  State<DoctorChatView> createState() => _DoctorChatViewState();
}

class _DoctorChatViewState extends State<DoctorChatView> {
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
    }
  ];

  //　チャット用のコントローラー
  final TextEditingController controller = TextEditingController();

  // フォーカス用のノード
  final focusNode = FocusNode();

  // スクロール用のコントローラー
  final ScrollController scrollController = ScrollController();

  // スクロール位置が最下部になるかどうかを判定するための変数
  bool isScrollEnd = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //画面が表示された時にスクロール位置が最下部になるようにする
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        setState(() {
          isScrollEnd = false;
        });
      } else {
        setState(() {
          isScrollEnd = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Focus(
      focusNode: focusNode,
      child: GestureDetector(
        onTap: focusNode.requestFocus,
        child: CustomScaffold(
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
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: chatList.length,
                            controller: scrollController,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              // todo: モデルに変更して当てはめる
                              return MessageTile(
                                  messageBody: chatList[index].keys.first,
                                  myMessage: chatList[index].values.first,
                                  postAt: '12:00');
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 80,
                      right: 20,
                      child: Visibility(
                        visible: isScrollEnd,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: ColorName.shadowGray,
                            borderRadius: BorderRadius.circular(20),
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
                    children: [
                      SizedBox(
                        width: size.width * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                          ),
                          child: CustomTextfield(
                            hintText: 'メッセージを入力',
                            controller: controller,
                            height: 44,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.1,
                        height: 44,
                        child: const Icon(
                          Icons.send,
                          color: Colors.blue,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
