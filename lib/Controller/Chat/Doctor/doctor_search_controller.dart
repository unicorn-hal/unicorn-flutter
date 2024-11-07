import 'package:unicorn_flutter/Model/Data/Department/department_data.dart';

import '../../../Model/Entity/Department/department.dart';
import '../../Core/controller_core.dart';

class DoctorSearchController extends ControllerCore {
  DoctorSearchController();

  late List<Department> _departmentList;

  @override
  void initialize() {
    _departmentList = DepartmentData().data;
  }

  List<Department> get departmentList => _departmentList;
}
