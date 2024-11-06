class ChatResponse {
  final String chatId;
  final String doctorId;
  final String userId;

  ChatResponse({
    required this.chatId,
    required this.doctorId,
    required this.userId,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      chatId: json['chatID'],
      doctorId: json['doctorID'],
      userId: json['userID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatID': chatId,
      'doctorID': doctorId,
      'userID': userId,
    };
  }
}
