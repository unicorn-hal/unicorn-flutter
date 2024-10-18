import 'package:contacts_service/contacts_service.dart' as package;
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/Model/Entiry/contact_user.dart';

class NativeContactsService {
  /// iOSのみ考慮: Nativeの連絡先を取得
  Future<List<package.Contact>> getNativeContacts() async {
    final Iterable<package.Contact> contacts =
        await package.ContactsService.getContacts();
    return contacts.toList();
  }

  /// iOSのみ考慮: Nativeの連絡先を取得し、ContactUserに変換
  Future<List<ContactUser>> getContactUsers() async {
    final List<package.Contact> nativeContacts = await getNativeContacts();
    final List<ContactUser> contactUsers = <ContactUser>[];
    for (final package.Contact nativeContact in nativeContacts) {
      Map<String, dynamic> contactMap = {
        'importFrom': ImportFrom.native,
        'displayName': nativeContact.displayName,
        'firstName': '${nativeContact.middleName}${nativeContact.givenName}',
        'lastName': nativeContact.familyName,
        'email': nativeContact.emails?.first ?? '',
        'phoneNumber': nativeContact.phones?.first ?? '',
      };
      if (nativeContact.avatar != null) {
        contactMap['avatar'] = Image.memory(nativeContact.avatar!);
      }
      final ContactUser contactUser = ContactUser.fromJson(contactMap);
      contactUsers.add(contactUser);
    }
    return contactUsers;
  }
}
