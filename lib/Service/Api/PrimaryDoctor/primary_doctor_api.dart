import 'package:unicorn_flutter/Model/Cache/Doctor/PrimaryDoctors/primary_doctors_cache.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/PrimaryDoctor/primary_doctors_request.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class PrimaryDoctorApi extends ApiCore with Endpoint {
  PrimaryDoctorApi() : super(Endpoint.primaryDoctors);

  /// GET
  /// 主治医一覧取得
  Future<List<Doctor>?> getPrimaryDoctorList() async {
    try {
      final response = await get();
      List<Doctor> doctors = (response.data['data'] as List)
          .map((e) => Doctor.fromJson(e))
          .toList();
      List<String> doctorIds = doctors.map((e) => e.doctorId).toList();
      PrimaryDoctorsCache().setData(doctorIds);
      return doctors;
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// [body] PrimaryDoctorsRequest
  Future<int> postPrimaryDoctor({required PrimaryDoctorsRequest body}) async {
    try {
      final response = await post(body.toJson());
      if (response.statusCode == 200) {
        PrimaryDoctorsCache().addData(body.doctorId);
      }
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// DELETE
  Future<int> deletePrimaryDoctor({
    required String doctorId,
  }) async {
    try {
      useParameter(parameter: '/$doctorId');
      final ApiResponse response = await delete();
      print(response.statusCode);
      if (response.statusCode == 204) {
        PrimaryDoctorsCache().removeData(doctorId);
      }
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
