import 'package:unicorn_flutter/Model/Entity/Call/call.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class CallApi extends ApiCore with Endpoint {
  CallApi() : super(Endpoint.calls);

  /// GET
  /// 通話情報取得
  /// [doctorId] 医師ID
  /// [userId] ユーザID
  Future<List<Call>?> getCall({
    required String doctorId,
    required String userId,
  }) async {
    try {
      useParameter(parameter: '?doctorID=$doctorId&userID=$userId');
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => Call.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// 通話予約
  /// [body] CallRequest
  Future<int> postCall({required CallRequest body}) async {
    try {
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// PUT
  /// 通話情報更新
  /// [body] CallRequest
  /// [callReservationId] 通話予約ID
  Future<int> putCall({
    required CallRequest body,
    required String callReservationId,
  }) async {
    try {
      useParameter(parameter: '/$callReservationId');
      final ApiResponse response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// DELETE
  /// 通話情報削除
  /// [callReservationId] 通話予約ID
  Future<int> deleteCall({required String callReservationId}) async {
    try {
      useParameter(parameter: '/$callReservationId');
      final ApiResponse response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
