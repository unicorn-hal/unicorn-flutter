import 'package:unicorn_flutter/Model/Entity/Chat/chat.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_request.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/chat_response.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message_request.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class ChatApi extends ApiCore with Endpoint {
  ChatApi() : super(Endpoint.chats);

  /// GET
  /// チャット一覧取得
  Future<List<Chat>?> getChatList() async {
    try {
      final response = await get();
      return (response.data['data'] as List)
          .map((e) => Chat.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// チャット作成
  /// [body] ChatRequest
  Future<ChatResponse?> postChat({
    required ChatRequest body,
  }) async {
    try {
      final response = await post(body.toJson());
      return ChatResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// GET
  /// チャットメッセージ一覧取得
  /// [chatId] チャットID
  Future<List<Message>?> getMessageList({required String chatId}) async {
    try {
      useParameter(parameter: '/$chatId/messages');
      final response = await get();
      return (response.data['data'] as List)
          .map((e) => Message.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// チャットメッセージ作成
  /// [body] MessageRequest
  /// [chatId] チャットID
  Future<MessageResponse?> postMessage({
    required MessageRequest body,
    required String chatId,
  }) async {
    try {
      useParameter(parameter: '/$chatId/messages');
      final response = await post(body.toJson());
      return MessageResponse.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// DELETE
  /// チャットメッセージ削除
  /// [chatId] チャットID
  /// [messageId] メッセージID
  Future<int> deleteMessage({
    required String chatId,
    required String messageId,
  }) async {
    try {
      useParameter(parameter: '/$chatId/messages/$messageId');
      final response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
