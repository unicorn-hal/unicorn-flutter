import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class HealthCheckupApi extends ApiCore with Endpoint {
  HealthCheckupApi() : super(Endpoint.healthCheckups);

  /// GET
  /// 健康結果一覧取得
  Future<List<HealthCheckup>?> getHealthCheckupList() async {
    try {
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => HealthCheckup.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// 健康結果登録
  /// [body] HealthCheckupRequest
  Future<int> postHealthCheckup({required HealthCheckupRequest body}) async {
    try {
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// GET
  /// 健康結果取得
  /// [healthCheckupId] 健康診断ID
  Future<HealthCheckup?> getHealthCheckupById(
      {required String healthCheckupId}) async {
    try {
      useParameter(parameter: '/$healthCheckupId');
      final ApiResponse response = await get();
      return HealthCheckup.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// PUT
  /// 健康結果更新
  /// [healthCheckupId] 健康診断ID
  /// [body] HealthCheckupRequest
  Future<int> putHealthCheckup(
      {required String healthCheckupId,
      required HealthCheckupRequest body}) async {
    try {
      useParameter(parameter: '/$healthCheckupId');
      final ApiResponse response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// DELETE
  /// 健康結果削除
  /// [healthCheckupId] 健康診断ID
  Future<int> deleteHealthCheckup({required String healthCheckupId}) async {
    try {
      useParameter(parameter: '/$healthCheckupId');
      final ApiResponse response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
