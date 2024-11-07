import '../../Entity/Department/department.dart';

class DepartmentData {
  static final DepartmentData _instance = DepartmentData._internal();
  factory DepartmentData() => _instance;
  DepartmentData._internal();

  List<Department>? _data;

  List<Department> get data => _data ?? [];

  void setDepartment(List<Department> data) {
    _data = data;
  }
}
