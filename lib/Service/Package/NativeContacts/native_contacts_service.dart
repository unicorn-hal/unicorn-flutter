import 'package:contacts_service/contacts_service.dart' as package;
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_post_request.dart';
import 'package:uuid/uuid.dart';

class NativeContactsService {
  /// iOSのみ考慮: Nativeの連絡先を取得
  Future<List<package.Contact>> getNativeContacts() async {
    final Iterable<package.Contact> contacts =
        await package.ContactsService.getContacts();
    return contacts.toList();
  }

  /// iOSのみ考慮: Nativeの連絡先を取得し、FamilyEmailRequestに変換
  Future<List<FamilyEmailPostRequest>> getFamilyEmailRequests() async {
    final List<package.Contact> nativeContacts = await getNativeContacts();
    final List<FamilyEmailPostRequest> familyEmailRequests =
        <FamilyEmailPostRequest>[];
    for (final package.Contact nativeContact in nativeContacts) {
      final familyEmailId = const Uuid().v4();
      final firstName = nativeContact.givenName ?? '';
      final lastName = nativeContact.familyName ?? '';
      final email = nativeContact.emails!.isNotEmpty
          ? nativeContact.emails!.first.value
          : '';
      final Map<String, dynamic> contactMap = {
        'familyEmailID': familyEmailId,
        'firstName': firstName,
        'lastName': lastName,
        'email': '$email',
      };
      if (nativeContact.avatar != null) {
        contactMap['avatar'] = nativeContact.avatar;
      }
      final FamilyEmailPostRequest contactUser =
          FamilyEmailPostRequest.fromJson(contactMap);
      familyEmailRequests.add(contactUser);
    }
    return familyEmailRequests;
  }
}
