import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_request.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_notification.dart';
import 'package:unicorn_flutter/Model/Entity/User/user_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

import '../../../Model/Data/HealthCheckup/health_checkup_data.dart';

class UserApi extends ApiCore with Endpoint {
  UserApi() : super(Endpoint.users);

  /// GET
  /// [userId] ユーザーID
  Future<User?> getUser({required String userId}) async {
    try {
      useParameter(parameter: '/$userId');
      final ApiResponse response = await get();
      return User.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// GET
  /// ユーザーの健康診断結果一覧取得
  /// [userId] ユーザーID
  Future<List<HealthCheckup>?> getUserHealthCheckupList(
      {required String userId}) async {
    try {
      useParameter(parameter: '/$userId/health_checkups');
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => HealthCheckup.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// GET
  /// ユーザーの健康診断結果取得
  /// [userId] ユーザーID
  /// [healthCheckupId] 健康診断ID
  Future<HealthCheckup?> getUserHealthCheckup({
    required String userId,
    required String healthCheckupId,
  }) async {
    try {
      useParameter(parameter: '/$userId/health_checkups/$healthCheckupId');
      final ApiResponse response = await get();
      return HealthCheckup.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<UserNotification?> getUserNotification(
      {required String userId}) async {
    try {
      useParameter(parameter: '/$userId/notification');
      final ApiResponse response = await get();
      return UserNotification.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// ユーザー登録
  /// [body] UserRequest
  Future<int> postUser({required UserRequest body}) async {
    try {
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// POST
  /// ユーザー通知設定登録
  /// [body] UserNotification
  Future<UserNotification?> postUserNotification({
    required String userId,
    required UserNotification body,
  }) async {
    try {
      useParameter(parameter: '/$userId/notification');
      final ApiResponse response = await post(body.toJson());
      return UserNotification.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// PUT
  /// ユーザー情報更新
  /// [userId] ユーザーID
  /// [body] UserRequest
  Future<int> putUser({
    required String userId,
    required UserRequest body,
  }) async {
    try {
      useParameter(parameter: '/$userId');
      final ApiResponse response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// PUT
  /// ユーザー健康診断結果更新
  /// [userId] ユーザーID
  /// [healthCheckupId] 健康診断ID
  /// [body] HealthCheckupRequest
  Future<int?> putUserHealthCheckup({
    required String userId,
    required String healthCheckupId,
    required HealthCheckupRequest body,
  }) async {
    try {
      useParameter(parameter: '/$userId/health_checkups/$healthCheckupId');
      final ApiResponse response = await put(body.toJson());

      if (response.statusCode != 200) {
        return response.statusCode;
      }
      //成功時にはHealthCheckupDataにあるデータを更新
      HealthCheckupCache().updateData(HealthCheckup.fromJson(response.data));

      return response.statusCode;
    } catch (e) {
      return null;
    }
  }

  /// PUT
  /// ユーザー通知設定更新
  /// [userId] ユーザーID
  /// [body] UserNotification
  Future<int> putUserNotification({
    required String userId,
    required UserNotification body,
  }) async {
    try {
      useParameter(parameter: '/$userId/notification');
      final ApiResponse response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// DELETE
  /// ユーザー削除
  /// [userId] ユーザーID
  Future<int> deleteUser({required String userId}) async {
    try {
      useParameter(parameter: '/$userId');
      final ApiResponse response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
