class ChatUser {
  final String userId;
  final String? userIconUrl;
  final String firstName;
  final String lastName;

  ChatUser({
    required this.userId,
    required this.userIconUrl,
    required this.firstName,
    required this.lastName,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      userId: json['userID'],
      userIconUrl: json['userIconUrl'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userId,
      'userIconUrl': userIconUrl,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
