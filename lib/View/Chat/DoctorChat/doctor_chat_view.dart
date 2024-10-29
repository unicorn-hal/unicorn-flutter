import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_textfield.dart';
import 'package:unicorn_flutter/View/Component/Parts/Chat/message_tile.dart';

class DoctorChatView extends StatelessWidget {
  DoctorChatView({super.key});

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
              Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: chatList.length,
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

              ///チャット入力部,
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: size.width,
                  height: 60,
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
