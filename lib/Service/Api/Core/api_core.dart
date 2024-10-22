import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Firebase/Authentication/authentication_service.dart';

abstract class ApiCore {
  FirebaseAuthenticationService get authService =>
      FirebaseAuthenticationService();

  final String _baseUrl = dotenv.env['UNICORN_API_BASEURL']!;
  String _idToken = '';
  String endPoint = '';
  String _parameter = '';
  late Map<String, String> _headers;

  /// コンストラクタ
  ApiCore(this.endPoint);

  /// URL作成
  String get _url => '$_baseUrl$endPoint/$_parameter';

  /// パラメータセット
  /// [parameter] パラメータ
  void useParameter({required String parameter}) {
    _parameter = parameter;
  }

  /// ヘッダー作成
  Future<void> makeHeader() async {
    _idToken = await authService.getIdToken() ?? '';
    _headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $_idToken',
      'X-UID': authService.getUid() ?? '',
    };
  }

  /// GET
  @protected
  Future<ApiResponse> get() async {
    try {
      await makeHeader();
      print(_url);
      http.Response response = await http.get(
        Uri.parse(_url),
        headers: _headers,
      );
      if (response.statusCode != 200) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: 'GET Failed',
          data: {},
        );
      }

      final String responseUtf8 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseUtf8);

      return ApiResponse.fromJson({
        'statusCode': response.statusCode,
        'message': 'Success',
        'data': jsonResponse,
      });
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: e.toString(),
        data: {},
      );
    }
  }

  /// POST
  /// [body] 送信データ
  @protected
  Future<ApiResponse> post(Map<String, dynamic> body) async {
    try {
      await makeHeader();
      http.Response response = await http.post(
        Uri.parse(_url),
        headers: _headers,
        body: json.encode(body),
      );
      if (response.statusCode != 200) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: 'POST Failed',
          data: {},
        );
      }
      final String responseUtf8 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseUtf8);

      return ApiResponse.fromJson({
        'statusCode': response.statusCode,
        'message': 'Success',
        'data': jsonResponse,
      });
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: e.toString(),
        data: {},
      );
    }
  }

  /// PUT
  /// [body] 送信データ
  @protected
  Future<ApiResponse> put(Map<String, dynamic> body) async {
    try {
      await makeHeader();
      http.Response response = await http.put(
        Uri.parse(_url),
        headers: _headers,
        body: json.encode(body),
      );
      if (response.statusCode != 200) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: 'PUT Failed',
          data: {},
        );
      }

      final String responseUtf8 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseUtf8);

      return ApiResponse.fromJson({
        'statusCode': response.statusCode,
        'message': 'Success',
        'data': jsonResponse,
      });
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: e.toString(),
        data: {},
      );
    }
  }

  /// DELETE
  @protected
  Future<ApiResponse> delete() async {
    try {
      await makeHeader();
      http.Response response = await http.delete(
        Uri.parse(_url),
        headers: _headers,
      );
      if (response.statusCode != 204) {
        return ApiResponse(
          statusCode: response.statusCode,
          message: 'DELETE Failed',
          data: {},
        );
      }

      return ApiResponse.fromJson({
        'statusCode': response.statusCode,
        'message': 'Success',
      });
    } catch (e) {
      return ApiResponse(
        statusCode: 500,
        message: e.toString(),
        data: {},
      );
    }
  }
}
