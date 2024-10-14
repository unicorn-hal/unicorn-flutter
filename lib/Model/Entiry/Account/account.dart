class Account {
  final String? id;
  final String? role;
  final String? fcmTokenId;

  Account({
    required this.id,
    required this.role,
    required this.fcmTokenId,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      role: json['role'],
      fcmTokenId: json['fcmTokenId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'fcmTokenId': fcmTokenId,
    };
  }
}
