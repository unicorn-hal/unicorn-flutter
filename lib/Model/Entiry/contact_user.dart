import 'package:flutter/material.dart';

enum ImportFrom {
  native, // Nativeから同期した連絡先 (ローカル)
  manual, // 手動で追加した連絡先 (ローカル)
  server, // サーバーから取得した連絡先 (リモート)
}

class ContactUser {
  final ImportFrom importFrom;
  final String displayName;
  final String givinName;
  final String familyName;
  final String email;
  final String phoneNumber;
  // todo: デフォルトavatarImageがAssetsに登録されたら、初期値として設定する
  final Image? avatar;
  final String? imagePath;

  ContactUser({
    required this.importFrom,
    required this.displayName,
    required this.givinName,
    required this.familyName,
    required this.email,
    required this.phoneNumber,
    this.avatar,
    this.imagePath,
  });

  factory ContactUser.fromJson(Map<String, dynamic> json) {
    return ContactUser(
      importFrom: json['importFrom'],
      displayName: json['displayName'],
      givinName: json['givinName'],
      familyName: json['familyName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      avatar: json['avatar'],
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'importFrom': importFrom,
      'displayName': displayName,
      'givinName': givinName,
      'familyName': familyName,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'imagePath': imagePath,
    };
  }
}
