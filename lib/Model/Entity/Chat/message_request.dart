class MessageRequest {
  final String senderId;
  final String content;

  MessageRequest({
    required this.senderId,
    required this.content,
  });

  factory MessageRequest.fromJson(Map<String, dynamic> json) {
    return MessageRequest(
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
