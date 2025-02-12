import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_message.dart';

class ChatGPTResponse {
  ChatGPTResponse({
    required this.created,
    required this.message,
  });

  final DateTime created;
  final ChatGPTMessage message;

  factory ChatGPTResponse.fromJson(Map<String, dynamic> json) {
    return ChatGPTResponse(
      created: DateTime.fromMillisecondsSinceEpoch(
        json['created'] * 1000,
      ),
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
