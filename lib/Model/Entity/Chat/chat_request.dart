class ChatRequest {
  final String doctorId;
  final String userId;

  ChatRequest({
    required this.doctorId,
    required this.userId,
  });

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      doctorId: json['doctorID'],
      userId: json['userID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorID': doctorId,
      'userID': userId,
    };
  }
}
