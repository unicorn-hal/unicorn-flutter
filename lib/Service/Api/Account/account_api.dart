import 'package:unicorn_flutter/Model/Entiry/Account/account.dart';
import 'package:unicorn_flutter/Model/Entiry/Account/account_request.dart';
import 'package:unicorn_flutter/Model/Entiry/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';

class AccountApi extends ApiCore {
  AccountApi() : super('accounts');

  /// GET
  Future<Account?> getAccount() async {
    try {
      final ApiResponse response = await get();
      return Account.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// [body] AccountRequest
  Future<int> postAccount(AccountRequest body) async {
    try {
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// DELETE
  Future<int> deleteAccount() async {
    try {
      final ApiResponse response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
