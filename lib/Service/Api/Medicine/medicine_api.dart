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
      _medicineCache.setMedicineList(data);
      return data;
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// [body] MedicineRequest
  Future<Medicine?> postMedicine({required MedicineRequest body}) async {
    try {
      final ApiResponse response = await post(body.toJson());
      // todo: API側のPOSTレスポンスが変更されたら修正する
      final Medicine data = Medicine.fromJson({
        ...response.data,
        'reminders': body.reminders.map((e) => e.toJson()).toList(),
      });
      _medicineCache.addMedicine(data);
      return data;
    } catch (e) {
      return null;
    }
  }

  /// PUT
  /// [medicineId] 薬ID
  /// [body] MedicineRequest
  Future<Medicine?> putMedicine({
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
      _medicineCache.updateMedicine(data);
      return data;
    } catch (e) {
      return null;
    }
  }

  /// DELETE
  /// [medicineId] 薬ID
  Future<int> deleteMedicine({required String medicineId}) async {
    try {
      useParameter(parameter: '/$medicineId');
      final ApiResponse response = await delete();
      _medicineCache.deleteMedicine(medicineId);
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
