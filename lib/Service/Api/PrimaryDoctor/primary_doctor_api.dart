import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/PrimaryDoctor/primary_doctors_request.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class PrimaryDoctorApi extends ApiCore with Endpoint {
  PrimaryDoctorApi() : super(Endpoint.primaryDoctors);

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

  Future<int> postPrimaryDoctor({required PrimaryDoctorsRequest body}) async {
    try {
      final response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future<int> putPrimaryDoctor({
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
