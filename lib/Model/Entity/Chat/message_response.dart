class MessageResponse {
  final String senderId;
  final String content;

  MessageResponse({
    required this.senderId,
    required this.content,
  });

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      senderId: json['senderID'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderID': senderId,
      'content': content,
    };
  }
}
