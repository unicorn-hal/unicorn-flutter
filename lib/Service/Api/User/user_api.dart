import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';

class UserApi extends ApiCore {
  UserApi() : super('users');

  /// パラメーター設定
  /// [userId] ユーザーID
  void setUserId(String userId) {
    parameter = userId;
  }

  /// GET
  /// [userId] ユーザーID
  Future<User?> getUser(String userId) async {
    try {
      setUserId(userId);
      final ApiResponse response = await get();
      return User.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// [body] UserRequest
  Future<int> postUser(UserRequest body) async {
    try {
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// PUT
  /// [userId] ユーザーID
  /// [body] UserRequest
  Future<int> putUser(String userId, UserRequest body) async {
    try {
      setUserId(userId);
      final ApiResponse response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// DELETE
  /// [userId] ユーザーID
  Future<int> deleteUser(String userId) async {
    try {
      setUserId(userId);
      final ApiResponse response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
