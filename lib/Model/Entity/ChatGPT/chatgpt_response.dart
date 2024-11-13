import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_message.dart';

class ChatGPTResponse {
  ChatGPTResponse({
    required this.id,
    required this.created,
    required this.message,
  });

  final String id;
  final DateTime created;
  final ChatGPTMessage message;

  factory ChatGPTResponse.fromJson(Map<String, dynamic> json) {
    return ChatGPTResponse(
      id: json['id'],
      created: DateTime.fromMillisecondsSinceEpoch(json['created']),
      message: ChatGPTMessage.fromJson(json['choices'][0]['message']),
    );
  }
}
