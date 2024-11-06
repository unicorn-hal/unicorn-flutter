import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease.dart';
import 'package:unicorn_flutter/Model/Entity/ChronicDisease/chronic_disease_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class ChronicDiseaseApi extends ApiCore with Endpoint {
  ChronicDiseaseApi() : super(Endpoint.chronicDiseases);

  Future<List<ChronicDisease>?> getChronicDiseaseList() async {
    try {
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => ChronicDisease.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<int> postChronicDisease({
    required ChronicDiseaseRequest body,
  }) async {
    try {
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future<int> deleteChronicDisease({
    required String chronicDiseaseId,
  }) async {
    try {
      useParameter(parameter: '/$chronicDiseaseId');
      final ApiResponse response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
