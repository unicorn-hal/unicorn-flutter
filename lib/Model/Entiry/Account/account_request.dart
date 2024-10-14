class AccountRequest {
  final String? id;
  final String? role;
  final String? fcmTokenId;

  AccountRequest({
    required this.id,
    required this.role,
    required this.fcmTokenId,
  });

  factory AccountRequest.fromJson(Map<String, dynamic> json) {
    return AccountRequest(
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
