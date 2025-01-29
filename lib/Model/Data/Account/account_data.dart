import 'package:unicorn_flutter/Model/Entity/Account/account.dart';

class AccountData {
  static final AccountData _instance = AccountData._internal();
  factory AccountData() => _instance;
  AccountData._internal();

  Account? _account;

  Account? get account => _account;

  void setAccount(Account account) {
    _account = account;
  }
}
