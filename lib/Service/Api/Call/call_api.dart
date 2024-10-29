import 'package:unicorn_flutter/Model/Entity/Call/call.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_request.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class CallApi extends ApiCore with Endpoint {
  CallApi() : super(Endpoint.calls);

  Future<Call?> getCall({
    required String doctorId,
    required String userId,
  }) async {
    try {
      useParameter(parameter: '?doctorID=$doctorId&userID=$userId');
      final response = await get();
      return Call.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<int> postCall({required CallRequest body}) async {
    try {
      final response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
