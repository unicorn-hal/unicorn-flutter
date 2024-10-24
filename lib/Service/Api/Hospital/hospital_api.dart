import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/Hospital/hospital.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class HospitalApi extends ApiCore with Endpoint {
  HospitalApi() : super(Endpoint.hospitals);

  /// GET
  /// 病院一覧取得
  Future<List<Hospital>?> getHospitalList() async {
    try {
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => Hospital.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// GET
  /// 病院情報取得
  /// [hospitalId] 病院ID
  Future<Hospital?> getHospital({required String hospitalId}) async {
    try {
      useParameter(parameter: '/$hospitalId');
      final ApiResponse response = await get();
      return Hospital.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  /// GET
  /// 病院ごとの医師一覧取得
  /// [hospitalId] 病院ID
  Future<List<Doctor>?> getDoctorListByHospital(
      {required String hospitalId}) async {
    try {
      useParameter(parameter: '/$hospitalId/doctors');
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => Doctor.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
