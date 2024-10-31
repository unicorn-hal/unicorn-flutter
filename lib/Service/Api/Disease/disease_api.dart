import 'package:unicorn_flutter/Model/Entity/Disease/disease.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class DiseaseApi extends ApiCore with Endpoint {
  DiseaseApi() : super(Endpoint.diseases);

  /// GET
  /// 病名から病気一覧を取得
  /// [diseaseName] 病名
  Future<List<Disease>?> getDiseaseList({
    required String diseaseName,
  }) async {
    try {
      if (diseaseName == '' || diseaseName == ' ') {
        return null;
      }

      useParameter(parameter: '?diseaseName=$diseaseName');
      final response = await get();
      return (response.data['data'] as List)
          .map((e) => Disease.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// GET
  /// 有名な病気一覧を取得
  Future<List<Disease>?> getFamousDiseaseList() async {
    useParameter(parameter: '/famous');
    try {
      final response = await get();
      return (response.data['data'] as List)
          .map((e) => Disease.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
