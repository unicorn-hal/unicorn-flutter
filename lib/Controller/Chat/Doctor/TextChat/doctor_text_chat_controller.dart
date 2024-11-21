import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Model/Chat/chat_data.dart';

import 'package:unicorn_flutter/Model/Data/Account/account_data.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_request.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_response.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message_request.dart';
import 'package:unicorn_flutter/Service/Api/Chat/chat_api.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

import '../../../Core/controller_core.dart';

class DoctorTextChatController extends ControllerCore {
  ChatApi get _chatApi => ChatApi();

  DoctorTextChatController(
    this._doctorId,
    this._reserveMessage,
  );

  late bool _firstMessage;
  late String _chatId;
  final String _doctorId;
  final String? _reserveMessage;

  late ValueNotifier<List<Message>> _messageHistory;

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
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
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

    // 予約メッセージがある場合は送信
    if (_reserveMessage != null) {
      await sendReserveMessage();
    }
  }

  /// 該当医師とのチャット履歴があるかチェックする
  Future<bool> _chatMessageNotExists() async {
    final chatList = ChatData().data;
    // 該当医師とのチャット履歴がない場合true
    return !chatList.any((element) => element.doctor.doctorId == _doctorId);
  }

  /// 該当医師とのチャットIDを取得
  Future<String> _getChatId() async {
    final String chatId = ChatData()
        .data
        .firstWhere((element) => element.doctor.doctorId == _doctorId)
        .chatId;
    return chatId;
  }

  /// 初回メッセージの場合に新規チャットを作成
  Future<String> _createChat() async {
    ChatRequest body =
        ChatRequest(doctorId: _doctorId, userId: AccountData().account!.uid);
    ChatResponse? response = await _chatApi.postChat(body: body);

    if (response == null) {
      // todo: エラー時はアプリを再起動させる
    }

    // チャットIDからメッセージ履歴を取得
    List<Chat>? chatList = await _chatApi.getChatList();

    if (chatList == null) {
      // todo: エラー時はアプリを再起動させる
    }

    final Chat newChat = chatList!.firstWhere(
      (element) => element.chatId == response!.chatId,
    );

    // 新規作成したチャットをデータクラスに追加
    ChatData().addChat(newChat);

    return response!.chatId;
  }

  /// チャットIDからメッセージ履歴を取得
  Future<void> _getMessageHistory() async {
    final List<Message> messageList =
        await _chatApi.getMessageList(chatId: _chatId) ?? [];
    _messageHistory.value = messageList.reversed.toList();
  }

  /// メッセージの受信を開始
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
                  Log.echo('$e');
                }
              });
        },
        onStompError: (StompFrame frame) {
          // todo: エラー処理
        },
        onDisconnect: (StompFrame frame) {
          // 切断時にStreamを閉じる
          stompClient.deactivate();
        },
      ),
    );

    // アクティベート
    stompClient.activate();
  }

  /// テキストフィールドに入力されたメッセージを送信
  Future<void> sendMessage() async {
    MessageRequest message = MessageRequest(
      senderId: AccountData().account!.uid,
      content: chatController.text,
    );
    chatController.text = '';
    final response = await _chatApi.postMessage(body: message, chatId: _chatId);

    // 200以外の場合はエラーを表示
    if (response.hashCode != 200) {
      Fluttertoast.showToast(msg: Strings.CHAT_POST_RESPONSE_ERROR);
    }
  }

  /// 予約メッセージを送信
  Future<void> sendReserveMessage() async {
    MessageRequest message = MessageRequest(
      senderId: AccountData().account!.uid,
      content: _reserveMessage!,
    );
    final response = await _chatApi.postMessage(body: message, chatId: _chatId);

    // 200以外の場合はエラーを表示
    if (response.hashCode != 200) {
      Fluttertoast.showToast(msg: Strings.CHAT_POST_RESPONSE_ERROR);
    }
  }

  // チャット履歴を逆順にして返す
  ValueNotifier<List<Message>> get messageHistory => _messageHistory;
}
