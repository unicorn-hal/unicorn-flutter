import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_message.dart';

class ChatGPTChat {
  ChatGPTChat({
    required this.created,
    required this.message,
  });

  final DateTime created;
  final ChatGPTMessage message;

  factory ChatGPTChat.fromJson(Map<String, dynamic> json) {
    return ChatGPTChat(
      created: DateTime.fromMillisecondsSinceEpoch(json['created']),
      message: ChatGPTMessage.fromJson(json['choices'][0]['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'created': created.millisecondsSinceEpoch,
      'message': message.toJson(),
    };
  }
}
