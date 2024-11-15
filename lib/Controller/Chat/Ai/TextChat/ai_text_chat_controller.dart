import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/chatgpt_role.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_response.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

import '../../../../Constants/app_data_constants.dart';
import '../../../../Model/Entity/ChatGPT/chatgpt_chat.dart';
import '../../../../Model/Entity/ChatGPT/chatgpt_message.dart';
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

  // AIが思考中のフラグ
  bool _isThinking = false;

  @override
  void initialize() {
    _chatList = ValueNotifier([
      ChatGPTChat(
        created: DateTime.now(),
        message: ChatGPTMessage(
          content: '${AppDataConstant.appDescription}',
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

    if (response == null) {
      Log.echo('response is null');
      return;
    }

    // AIからの返信メッセージの追加
    ChatGPTChat responseMessage = ChatGPTChat.fromJson(response.toJson());
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
