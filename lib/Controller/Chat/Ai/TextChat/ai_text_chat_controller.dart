import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/chatgpt_role.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_response.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

import '../../../../Constants/app_data_constants.dart';
import '../../../../Model/Entity/ChatGPT/chatgpt_chat.dart';
import '../../../../Model/Entity/ChatGPT/chatgpt_message.dart';
import '../../../../Model/Entity/User/user.dart';
import '../../../../Service/ChatGPT/chatgpt_service.dart';

class AiTextChatController extends ControllerCore {
  ChatGPTService get _chatGPTService => ChatGPTService();

  // コンストラクタ
  AiTextChatController();

  // 変数の定義
  late ValueNotifier<List<ChatGPTChat>> _chatList;

  //　チャット用のコントローラー
  final TextEditingController messageController = TextEditingController();

  // スクロールコントローラー
  final ScrollController scrollController = ScrollController();

  // ユーザー情報
  final User _user = UserData().user!;

  // AIが思考中のフラグ
  bool _isThinking = false;

  @override
  void initialize() {
    // チャットリストには初期メッセージとしてsystem命令文を追加
    _chatList = ValueNotifier([
      ChatGPTChat(
        created: DateTime.now(),
        message: ChatGPTMessage(
          content: '''
                    ${AppDataConstant.appDescription}

                    # ユーザーの情報を以下に記載します
                    名前: ${_user.firstName + _user.lastName}
                    生年月日: ${_user.birthDate}
                    身長: ${_user.bodyHeight}
                    体重: ${_user.bodyWeight}
                    性別: ${_user.gender}

                    ''',
          role: ChatGPTRole.system,
        ),
      ),
    ]);
  }

  ValueNotifier<List<ChatGPTChat>> get chatList => _chatList;

  /// AIのへのメッセージ送信
  Future<void> postMessage() async {
    // テキストフィールドのバリデートチェック
    if (!_validateTextField()) {
      Fluttertoast.showToast(msg: 'メッセージを入力してください');
      return;
    }

    // 自分が送信したメッセージの追加
    ChatGPTChat newChat = ChatGPTChat(
      created: DateTime.now(),
      message: ChatGPTMessage(
        content: messageController.text,
        role: ChatGPTRole.user,
      ),
    );

    // メッセージコントローラーのクリア
    messageController.text = '';

    // チャットリストに追加
    _chatList.value = [..._chatList.value, newChat];

    // フラグを思考中に変更
    _changeIsThinking();

    // AIへリストを送信
    final ChatGPTResponse? response = await _chatGPTService.postChatGPTMessage(
      _chatList.value.map((e) => e.message).toList(),
    );

    // フラグを思考終了に変更
    _changeIsThinking();

    late ChatGPTChat responseMessage;

    // 通信失敗などで返信がない場合はエラー内容をリストへ追加する
    if (response == null) {
      responseMessage = ChatGPTChat(
        created: DateTime.now(),
        message: ChatGPTMessage(
            role: ChatGPTRole.assistant,
            content: '通信が不安定で回答を取得できませんでした。\nもう一度お試しください。'),
      );
    } else {
      // AIからの返信メッセージの追加
      responseMessage = ChatGPTChat.fromJson(response.toJson());
    }

    _chatList.value = [..._chatList.value, responseMessage];
  }

  /// テキストフィールドのバリデートチェック
  bool _validateTextField() {
    final message = messageController.text;
    if (message.isEmpty) {
      return false;
    }
    return true;
  }

  /// AIが思考中のフラグを変更
  void _changeIsThinking() {
    _isThinking = !_isThinking;
  }

  bool get isThinking => _isThinking;
}
