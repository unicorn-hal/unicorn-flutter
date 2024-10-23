import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class DoctorApi extends ApiCore with Endpoint {
  DoctorApi() : super(Endpoint.doctors);

  /// GET
  Future<List<Doctor>?> getDoctorList({
    String? doctorName,
    String? departmentId,
    String? hospitalName,
  }) async {
    try {
      String parameter = '';
      if (doctorName != null) {
        parameter += '?doctorName=$doctorName';
      }
      if (departmentId != null) {
        parameter += parameter.isEmpty
            ? '?departmentId=$departmentId'
            : '&departmentId=$departmentId';
      }
      if (hospitalName != null) {
        parameter += parameter.isEmpty
            ? '?hospitalName=$hospitalName'
            : '&hospitalName=$hospitalName';
      }
      useParameter(parameter: parameter);
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => Doctor.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
