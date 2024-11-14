enum ChatGPTRole {
  user,
  assistant,
  system,
}

class ChatGPTRoleType {
  static ChatGPTRole fromString(String role) {
    switch (role) {
      case 'user':
        return ChatGPTRole.user;
      case 'assistant':
        return ChatGPTRole.assistant;
      case 'system':
        return ChatGPTRole.system;
      default:
        throw Exception('Role not found');
    }
  }
}
