import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class UserApi extends ApiCore with Endpoint {
  UserApi() : super(Endpoint.users);

  /// ユーザーIDをセット
  /// [userId] ユーザーID
  @override
  void setParameter({required String parameter}) {
    this.parameter = parameter;
  }

  /// GET
  /// [userId] ユーザーID
  Future<User?> getUser({required String userId}) async {
    try {
      setParameter(parameter: userId);
      final ApiResponse response = await get();
      return User.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// [body] UserRequest
  Future<int> postUser({required UserRequest body}) async {
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
  Future<int> putUser({
    required String userId,
    required UserRequest body,
  }) async {
    try {
      setParameter(parameter: userId);
      final ApiResponse response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// DELETE
  /// [userId] ユーザーID
  Future<int> deleteUser({required String userId}) async {
    try {
      setParameter(parameter: userId);
      final ApiResponse response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
