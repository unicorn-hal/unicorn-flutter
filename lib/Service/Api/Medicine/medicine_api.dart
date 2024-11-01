import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class MedicineApi extends ApiCore with Endpoint {
  MedicineApi() : super(Endpoint.medicines);

  /// GET
  /// 薬一覧取得
  Future<List<Medicine>?> getMedicineList() async {
    try {
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => Medicine.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// [body] MedicineRequest
  Future<int> postMedicine({required MedicineRequest body}) async {
    try {
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// PUT
  /// [medicineId] 薬ID
  /// [body] MedicineRequest
  Future<int> putMedicine({
    required MedicineRequest body,
    required String medicineId,
  }) async {
    try {
      useParameter(parameter: '/$medicineId');
      final ApiResponse response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// DELETE
  /// [medicineId] 薬ID
  Future<int> deleteMedicine({required String medicineId}) async {
    try {
      useParameter(parameter: '/$medicineId');
      final ApiResponse response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
