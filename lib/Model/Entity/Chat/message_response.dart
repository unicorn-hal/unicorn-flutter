class MessageResponse {
  final String messageId;
  final String senderId;
  final String content;

  MessageResponse({
    required this.messageId,
    required this.senderId,
    required this.content,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      messageId: json['messageID'],
      senderId: json['senderID'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageID': messageId,
      'senderID': senderId,
      'content': content,
    };
  }
}
