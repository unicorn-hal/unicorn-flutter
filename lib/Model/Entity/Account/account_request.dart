import 'package:unicorn_flutter/Constants/Enum/user_role_enum.dart';

class AccountRequest {
  final String uid;
  final UserRoleEnum role;
  final String fcmTokenId;

  AccountRequest({
    required this.uid,
    required this.role,
    required this.fcmTokenId,
  });

  factory AccountRequest.fromJson(Map<String, dynamic> json) {
    return AccountRequest(
      uid: json['uid'],
      role: UserRoleType.fromString(json['role']),
      fcmTokenId: json['fcmTokenId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': UserRoleType.toStringValue(role),
      'fcmTokenId': fcmTokenId,
    };
  }
}
