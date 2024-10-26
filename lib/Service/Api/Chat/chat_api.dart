import 'package:unicorn_flutter/Model/Entity/Chat/chat.dart';
import 'package:unicorn_flutter/Model/Entity/Chat/message.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class ChatApi extends ApiCore with Endpoint {
  ChatApi() : super(Endpoint.chats);

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
