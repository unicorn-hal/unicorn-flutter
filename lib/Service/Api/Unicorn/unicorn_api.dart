import 'package:unicorn_flutter/Model/Entity/Emergency/emergency_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class UnicornApi extends ApiCore {
  UnicornApi() : super(Endpoint.unicorn);

  /// POST
  /// 緊急要請
  /// [body] EmergencyRequest
  Future<int> postEmergency({required EmergencyRequest body}) async {
    try {
      useParameter(parameter: '/emergency');
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
