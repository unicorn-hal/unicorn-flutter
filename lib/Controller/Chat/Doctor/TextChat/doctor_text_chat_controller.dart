import 'package:flutter/material.dart';

import 'package:unicorn_flutter/Model/Data/Account/account_data.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_request.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_response.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message.dart';
import 'package:unicorn_flutter/Service/Api/Chat/chat_api.dart';

import '../../../../Model/Entity/Chat/chat.dart';
import '../../../Core/controller_core.dart';

class DoctorTextChatController extends ControllerCore {
  ChatApi get _chatApi => ChatApi();
  DoctorTextChatController(
    this._doctorId,
  );

  late bool _firstMessage;
  late String _chatId;
  final String _doctorId;

  late ValueNotifier<List<Message>> _messageHistory;

  @override
  void initialize() async {
    _messageHistory = ValueNotifier([]);
    _firstMessage = await _chatMessageNotExists();
    if (_firstMessage) {
      _chatId = await _createChat();
    } else {
      _chatId = await _getChatId();
    }
    await _getMessageHistory();
  }

  // 該当医師とのチャット履歴があるか
  Future<bool> _chatMessageNotExists() async {
    final List<Chat> chatList = await _chatApi.getChatList() ?? [];
    // 該当医師とのチャット履歴がない場合true
    return !chatList.any((element) => element.doctor.doctorId == _doctorId);
  }

  // 該当医師とのチャットIDを取得
  Future<String> _getChatId() async {
    final List<Chat> chatList = await _chatApi.getChatList() ?? [];
    final Chat chat =
        chatList.firstWhere((element) => element.doctor.doctorId == _doctorId);
    print('chatId: ${chat.chatId}');
    return chat.chatId;
  }

  // 初回メッセージの場合は新規チャットを作成
  Future<String> _createChat() async {
    ChatRequest body =
        ChatRequest(doctorId: _doctorId, userId: AccountData().account!.uid);
    ChatResponse? response = await _chatApi.postChat(body: body);

    if (response == null) {
      // todo: エラー時はアプリを再起動させる
    }
    return response!.chatId;
  }

  // チャットIDからメッセージ履歴を取得
  Future<void> _getMessageHistory() async {
    final List<Message> messageList =
        await _chatApi.getMessageList(chatId: _chatId) ?? [];

    _messageHistory.value = messageList;
    print('messageHistory: $_messageHistory');
  }

  ValueNotifier<List<Message>> get messageHistory => _messageHistory;
}
