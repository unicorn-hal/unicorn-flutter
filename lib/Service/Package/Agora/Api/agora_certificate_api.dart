import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unicorn_flutter/Model/Entity/Agora/agora_certificate.dart';
import 'package:unicorn_flutter/Model/Entity/Agora/agora_certificate_request.dart';
import 'package:unicorn_flutter/Service/Firebase/Authentication/authentication_service.dart';
import 'package:http/http.dart' as http;

class AgoraCertificateApi {
  FirebaseAuthenticationService get authService =>
      FirebaseAuthenticationService();

  final String _baseUrl = dotenv.env['AGORA_CERTIFICATION_SERVER_URL']!;
  final String _endPoint = '/api/token';
  String _idToken = '';
  Map<String, String> _headers = {};

  /// コンストラクタ
  AgoraCertificateApi();

  /// URL作成
  String get _url => '$_baseUrl$_endPoint';

  /// ヘッダー作成
  Future<void> makeHeader() async {
    _idToken = await authService.getIdToken() ?? '';
    _headers = {
      'Content-type': 'application/json',
      'Authorization': 'Bearer $_idToken',
    };
  }

  /// トークン取得
  /// [body] リクエストボディ
  Future<AgoraCertificate?> fetchToken(
      {required AgoraCertificateRequest body}) async {
    try {
      await makeHeader();
      http.Response response = await http.post(
        Uri.parse(_url),
        headers: _headers,
        body: json.encode(body),
      );
      if (response.statusCode != 200) {
        return null;
      }

      final String responseUtf8 = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonResponse = json.decode(responseUtf8);

      return AgoraCertificate.fromJson(jsonResponse);
    } catch (e) {
      return null;
    }
  }
}
