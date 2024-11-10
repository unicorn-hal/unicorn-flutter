import 'package:unicorn_flutter/Model/Entity/Account/account.dart';
import 'package:unicorn_flutter/Model/Entity/Account/account_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class AccountApi extends ApiCore with Endpoint {
  AccountApi() : super(Endpoint.accounts);

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
  Future<int> postAccount({required AccountRequest body}) async {
    try {
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// PUT
  /// [fcmTokenId] FCMトークンID
  Future<int> putAccount({required String fcmTokenId}) async {
    try {
      final ApiResponse response = await put({'fcm_token_id': fcmTokenId});
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
