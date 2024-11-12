import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:unicorn_flutter/Model/Chat/chat_data.dart';

import 'package:unicorn_flutter/Model/Data/Account/account_data.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_request.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_response.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message_request.dart';
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
  late String _doctorName;
  final String _doctorId;

  late ValueNotifier<List<Message>> _messageHistory;
  StreamController<List> streamController = StreamController();

  // スクロール用のコントローラー
  final ScrollController scrollController = ScrollController();

  //テキストフィールド用のコントローラー
  final TextEditingController chatController = TextEditingController();

  @override
  void initialize() async {
    // メッセージ履歴の初期化
    _messageHistory = ValueNotifier([]);

    // メッセージリストの変更があればスクロール位置を最下部に移動
    _messageHistory.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(0.0);
        }
      });
    });

    // 初回メッセージの場合は新規チャットを作成
    _firstMessage = await _chatMessageNotExists();

    if (_firstMessage) {
      _chatId = await _createChat();
    } else {
      _chatId = await _getChatId();
    }
    await _getMessageHistory();

    // メッセージの受信を開始
    _listenNewMessage();
  }

  // 該当医師とのチャット履歴があるか
  Future<bool> _chatMessageNotExists() async {
    final chatList = ChatData().data;
    // 該当医師とのチャット履歴がない場合true
    return !chatList.any((element) => element.doctor.doctorId == _doctorId);
  }

  // 該当医師とのチャットIDを取得
  Future<String> _getChatId() async {
    final String chatId = ChatData()
        .data
        .firstWhere((element) => element.doctor.doctorId == _doctorId)
        .chatId;
    return chatId;
  }

  // 初回メッセージの場合は新規チャットを作成
  Future<String> _createChat() async {
    ChatRequest body =
        ChatRequest(doctorId: _doctorId, userId: AccountData().account!.uid);
    ChatResponse? response = await _chatApi.postChat(body: body);

    if (response == null) {
      // todo: エラー時はアプリを再起動させる
    }

    // 新規作成したチャットをデータクラスに追加
    ChatData().addChat(Chat.fromJson(response!.toJson()));
    return response.chatId;
  }

  // チャットIDからメッセージ履歴を取得
  Future<void> _getMessageHistory() async {
    final List<Message> messageList =
        await _chatApi.getMessageList(chatId: _chatId) ?? [];
    _messageHistory.value = messageList.reversed.toList();
  }

  // メッセージの受信を開始
  void _listenNewMessage() {
    late StompClient stompClient;
    String wsUrl =
        '${dotenv.env['UNICORN_API_BASEURL']!.replaceFirst(RegExp('https'), 'ws')}/ws';
    final String destination = '/topic/chats/$_chatId/messages';

    stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (StompFrame frame) {
          stompClient.subscribe(
              destination: destination,
              callback: (StompFrame frame) async {
                // Stringで受け取ったメッセージをjsonに変換
                final Map<String, dynamic> json =
                    jsonDecode(frame.body!) as Map<String, dynamic>;

                // メッセージを追加
                try {
                  final Message message = Message.fromJson(
                    json,
                  );
                  // index 0に追加
                  final List<Message> newMessageHistory = _messageHistory.value;
                  _messageHistory.value = List.from(_messageHistory.value)
                    ..add(message);
                  newMessageHistory.insert(0, message);
                  _messageHistory.value = newMessageHistory;
                } catch (e) {
                  print(e);
                }
              });
        },
        onStompError: (StompFrame frame) {
          // todo: エラー処理
        },
        onDisconnect: (StompFrame frame) {
          // 切断時にStreamを閉じる
          streamController.close();
        },
      ),
    );

    // アクティベート
    stompClient.activate();
  }

  // テキストフィールドに入力されたメッセージを送信
  Future<void> sendMessage() async {
    MessageRequest message = MessageRequest(
      senderId: AccountData().account!.uid,
      content: chatController.text,
    );
    chatController.text = '';
    await _chatApi.postMessage(body: message, chatId: _chatId);
  }

  // チャット履歴を逆順にして返す
  ValueNotifier<List<Message>> get messageHistory => _messageHistory;
}
