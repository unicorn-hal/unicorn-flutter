import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseCloudStrorageService {
  FirebaseStorage get _firebaseStorage => FirebaseStorage.instance;

  Future<String> _uploadFile(String path, File file,
      {SettableMetadata? metadata}) async {
    if (!file.existsSync()) {
      throw Exception('File does not exist: ${file.path}');
    }

    try {
      final ref = _firebaseStorage.ref().child(path);
      final metaData = metadata ?? SettableMetadata(contentType: 'image/png');
      await ref.putFile(file, metaData);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> uploadUserAvatar(String userId, File file) async {
    return await _uploadFile(
      'accounts/users/$userId/profile/avatar.png',
      file,
    );
  }

  Future<String> uploadFamilyEmailAvatar(
      String userId, String familyEmailId, File file) async {
    return await _uploadFile(
      'accounts/users/$userId/family_emails/$familyEmailId/profile/avatar.png',
      file,
    );
  }
}
