import 'package:unicorn_flutter/Model/Entity/Department/department.dart';
import 'package:unicorn_flutter/Model/Entity/api_response.dart';
import 'package:unicorn_flutter/Service/Api/Core/api_core.dart';
import 'package:unicorn_flutter/Service/Api/Core/endpoint.dart';

class DepartmentApi extends ApiCore with Endpoint {
  DepartmentApi() : super(Endpoint.departments);

  /// GET
  /// 診療科一覧取得
  Future<List<Department>?> getDepartmentList() async {
    try {
      final ApiResponse response = await get();
      return (response.data['data'] as List)
          .map((e) => Department.fromJson(e))
          .toList();
    } catch (e) {
      return null;
    }
  }
}
