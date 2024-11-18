import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_post_request.dart';
import 'package:unicorn_flutter/Model/Entity/FamilyEmail/family_email_request.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class FamilyEmailApi extends ApiCore with Endpoint {
  FamilyEmailApi() : super(Endpoint.familyEmails);

  /// GET
  /// 家族メールアドレス一覧取得
  Future<List<FamilyEmail>?> getFamilyEmailList() async {
    try {
      final response = await get();
      return (response.data['data'] as List)
          .map((e) => FamilyEmail.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// 家族メールアドレス登録
  /// [body] FamilyEmailRequest
  Future<int> postFamilyEmail({required FamilyEmailPostRequest body}) async {
    try {
      final response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// PUT
  /// 家族メールアドレス更新
  /// [familyEmailId] 家族メールアドレスID
  /// [body] FamilyEmailRequest
  Future<int> putFamilyEmail({
    required FamilyEmailPutRequest body,
    required String familyEmailId,
  }) async {
    try {
      useParameter(parameter: '/$familyEmailId');
      final response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// DELETE
  /// 家族メールアドレス削除
  /// [familyEmailId] 家族メールアドレスID
  Future<int> deleteFamilyEmail({required String familyEmailId}) async {
    try {
      useParameter(parameter: '/$familyEmailId');
      final response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
