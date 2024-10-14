import 'package:unicorn_flutter/Model/Entiry/Account/account.dart';
import 'package:unicorn_flutter/Model/Entiry/Account/account_request.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

class ApiAccount extends ApiCore {
  ApiAccount() : super('accounts');

  Future<Account?> getAccount() async {
    final Map<String, dynamic> response = await get();
    if (response.containsKey('statusCode')) {
      Log.echo(
          'GETACCOUNT statusCode: ${response['statusCode']} message: ${response['message']}');
      return null;
    }
    return Account.fromJson(response);
  }

  Future<int?> postAccount(AccountRequest body) async {
    final Map<String, dynamic> response = await post(body.toJson());
    if (response.containsKey('statusCode')) {
      Log.echo(
          'POSTACCOUNT statusCode: ${response['statusCode']} message: ${response['message']}');
      return null;
    }
    return null;
  }

  Future<int?> deleteAccount() async {
    final Map<String, dynamic> response = await delete();
    if (response.containsKey('statusCode')) {
      Log.echo(
          'DELETEACCOUNT statusCode: ${response['statusCode']} message: ${response['message']}');
      return null;
    }
    return null;
  }
}
