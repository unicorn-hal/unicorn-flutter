import 'package:unicorn_flutter/Model/Cache/Medicine/medicine_cache.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class MedicineApi extends ApiCore with Endpoint {
  final MedicineCache _medicineCache = MedicineCache();

  MedicineApi() : super(Endpoint.medicines);

  /// GET
  /// 薬一覧取得
  Future<List<Medicine>?> getMedicineList() async {
    try {
      final ApiResponse response = await get();
      final List<Medicine> data = (response.data['data'] as List)
          .map((e) => Medicine.fromJson(e))
          .toList();
      _medicineCache.setData(data);
      return data;
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// [body] MedicineRequest
  Future<int> postMedicine({required MedicineRequest body}) async {
    try {
      final ApiResponse response = await post(body.toJson());
      final Medicine data = Medicine.fromJson(response.data);
      _medicineCache.addData(data);
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
      final Medicine data = Medicine.fromJson({
        ...response.data,
        'medicineID': medicineId,
      });
      _medicineCache.updateData(data);
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
      _medicineCache.deleteData(medicineId);
      _medicineCache.setCarouselIndex(0);
      _medicineCache.carouselController.jumpToPage(0);
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
