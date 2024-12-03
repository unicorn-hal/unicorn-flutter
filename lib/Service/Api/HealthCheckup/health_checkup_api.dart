import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

import '../../../Model/Data/HealthCheckup/health_checkup_data.dart';

class HealthCheckupApi extends ApiCore with Endpoint {
  HealthCheckupApi() : super(Endpoint.healthCheckups);

  /// POST
  /// 健康結果登録
  /// [body] HealthCheckupRequest
  Future<int?> postHealthCheckup({required HealthCheckupRequest body}) async {
    try {
      final ApiResponse response = await post(body.toJson());

      if (response.statusCode != 200) {
        return response.statusCode;
      }

      //成功時にはHealthCheckupDataに値を追加
      HealthCheckupCache().addData(HealthCheckup.fromJson(response.data));

      return response.statusCode;
    } catch (e) {
      return null;
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
