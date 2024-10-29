import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/PrimaryDoctor/primary_doctors_request.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class PrimaryDoctorApi extends ApiCore with Endpoint {
  PrimaryDoctorApi() : super(Endpoint.primaryDoctors);

  /// GET
  /// 主治医一覧取得
  Future<List<Doctor>?> getPrimaryDoctorList() async {
    try {
      final response = await get();
      return (response.data['data'] as List)
          .map((e) => Doctor.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// POST
  /// [body] PrimaryDoctorsRequest
  Future<int> postPrimaryDoctors({required PrimaryDoctorsRequest body}) async {
    try {
      final response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  /// PUT
  /// [body] PrimaryDoctorsRequest
  Future<int> putPrimaryDoctors({
    required PrimaryDoctorsRequest body,
  }) async {
    try {
      final response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
