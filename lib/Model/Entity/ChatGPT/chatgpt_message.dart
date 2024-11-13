enum Role {
  user,
  assistant,
  system,
}

class RoleHelper {
  static Role fromString(String role) {
    switch (role) {
      case 'user':
        return Role.user;
      case 'assistant':
        return Role.assistant;
      case 'system':
        return Role.system;
      default:
        throw Exception('Role not found');
    }
  }
}

class ChatGPTMessage {
  ChatGPTMessage({
    required this.role,
    required this.content,
  });

  final Role role;
  final String content;

  factory ChatGPTMessage.fromJson(Map<String, dynamic> json) {
    return ChatGPTMessage(
      role: RoleHelper.fromString(json['role']),
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
