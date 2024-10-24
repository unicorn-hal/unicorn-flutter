import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctorRequest.dart';
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

  Future<int> postDoctor({required DoctorRequest body}) async {
    try {
      final ApiResponse response = await post(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future<Doctor?> getDoctor({required String doctorId}) async {
    try {
      useParameter(parameter: '/$doctorId');
      final ApiResponse response = await get();
      return Doctor.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<int> putDoctor({
    required String doctorId,
    required DoctorRequest body,
  }) async {
    try {
      useParameter(parameter: '/$doctorId');
      final ApiResponse response = await put(body.toJson());
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }

  Future<int> deleteDoctor({required String doctorId}) async {
    try {
      useParameter(parameter: '/$doctorId');
      final ApiResponse response = await delete();
      return response.statusCode;
    } catch (e) {
      return 500;
    }
  }
}
