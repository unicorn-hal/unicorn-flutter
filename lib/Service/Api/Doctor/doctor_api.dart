import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class DoctorApi extends ApiCore with Endpoint {
  DoctorApi() : super(Endpoint.doctors);

  /// GET
  /// 医師一覧取得
  /// [doctorName] 医師名
  /// [departmentId] 科ID
  /// [hospitalName] 病院名
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
            ? '?departmentID=$departmentId'
            : '&departmentID=$departmentId';
      }
      if (hospitalName != null) {
        parameter += parameter.isEmpty
            ? '?hospitalName=$hospitalName'
            : '&hospitalName=$hospitalName';
      }
      if (parameter.isNotEmpty) {
        useParameter(parameter: parameter);
      }
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => Doctor.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }

  /// GET
  /// 医師情報取得
  /// [doctorId] 医師ID
  Future<Doctor?> getDoctor({required String doctorId}) async {
    try {
      useParameter(parameter: '/$doctorId');
      final ApiResponse response = await get();
      return Doctor.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}
