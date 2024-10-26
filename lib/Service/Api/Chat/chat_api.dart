import 'package:unicorn_flutter/Model/Entity/Chat/chat.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message.dart';
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

  /// GET
  /// チャット情報取得
  /// [doctorId] 医師ID
  /// [userId] ユーザID
  Future<int> postChat({
    required String doctorId,
    required String userId,
  }) async {
    try {
      final response = await post({
        'doctorID': doctorId,
        'userID': userId,
      });
      return response.statusCode;
    } catch (e) {
      return 500;
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
  /// チャットメッセージ送信
  /// [chatId] チャットID
  /// [senderId] 送信者ID
  /// [content] メッセージ内容
  Future<int> postMessage({
    required String chatId,
    required String senderId,
    required String content,
  }) async {
    try {
      useParameter(parameter: '/$chatId/messages');
      final response = await post({
        'senderID': senderId,
        'content': content,
      });
      return response.statusCode;
    } catch (e) {
      return 500;
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
