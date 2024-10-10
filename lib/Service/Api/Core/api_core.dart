import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:unicorn_flutter/Service/Firebase/Authentication/authentication_service.dart';

abstract class ApiCore {
  FirebaseAuthenticationService get authService =>
      FirebaseAuthenticationService();
  String _baseUrl = dotenv.env['UNICORN_API_BASEURL']!;
  String _idToken = '';
  String endPoint = '';
  late Map<String, String> _headers;

  /// コンストラクタ
  ApiCore(this.endPoint) {
    _baseUrl += endPoint;
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
  Future<Map<String, dynamic>> get() async {
    try {
      await makeHeader();
      http.Response response = await http.get(
        Uri.parse(_baseUrl),
        headers: _headers,
      );
      final String responseUtf8 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseUtf8);
      return jsonResponse;
    } catch (e) {
      return {
        'statusCode': 500,
        'message': e.toString(),
      };
    }
  }

  /// POST
  /// [body] 送信データ
  Future<Map<String, dynamic>> post(Map<String, dynamic> body) async {
    try {
      await makeHeader();
      http.Response response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: json.encode(body),
      );
      final String responseUtf8 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseUtf8);
      return jsonResponse;
    } catch (e) {
      return {
        'statusCode': 500,
        'message': e.toString(),
      };
    }
  }

  /// PUT
  /// [body] 送信データ
  Future<Map<String, dynamic>> put(Map<String, dynamic> body) async {
    try {
      await makeHeader();
      http.Response response = await http.put(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: json.encode(body),
      );
      final String responseUtf8 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseUtf8);
      return jsonResponse;
    } catch (e) {
      return {
        'statusCode': 500,
        'message': e.toString(),
      };
    }
  }

  /// DELETE
  Future<Map<String, dynamic>> delete() async {
    try {
      await makeHeader();
      http.Response response = await http.delete(
        Uri.parse(_baseUrl),
        headers: _headers,
      );
      final String responseUtf8 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseUtf8);
      return jsonResponse;
    } catch (e) {
      return {
        'statusCode': 500,
        'message': e.toString(),
      };
    }
  }
}
