import '../../../Constants/Enum/chatgpt_role.dart';

class ChatGPTMessage {
  ChatGPTMessage({
    required this.role,
    required this.content,
  });

  final ChatGPTRole role;
  final String content;

  factory ChatGPTMessage.fromJson(Map<String, dynamic> json) {
    return ChatGPTMessage(
      role: ChatGPTRoleType.fromString(json['role']),
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role.name,
      'content': content,
    };
  }
}
