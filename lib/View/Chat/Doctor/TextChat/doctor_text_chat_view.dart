import 'package:flutter/material.dart';
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
  final TextEditingController controller = TextEditingController();

  // フォーカス用のノード
  final focusNode = FocusNode();

  // スクロール用のコントローラー
  final ScrollController scrollController = ScrollController();

  // スクロール位置が最下部になるかどうかを判定するための変数
  bool scrollButton = false;

  @override
  void initState() {
    super.initState();

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
          )
        ],
      ),
    );
  }
}
