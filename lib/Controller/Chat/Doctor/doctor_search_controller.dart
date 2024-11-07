import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Model/Data/Department/department_data.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';

import '../../../Model/Entity/Department/department.dart';
import '../../../Model/Entity/Doctor/doctor.dart';
import '../../Core/controller_core.dart';

class DoctorSearchController extends ControllerCore {
  DoctorApi get _doctorApi => DoctorApi();

  DoctorSearchController();

  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();

  late int _selectedDepartmentIndex;
  late List<Department> _departmentList;
  late List<Doctor> _doctorList;

  @override
  void initialize() {
    _departmentList = DepartmentData().data;
    _selectedDepartmentIndex = 0;
    _doctorList = [];

    print(_doctorList);
  }

  List<Department> get departmentList => _departmentList;

  TextEditingController get hospitalNameController => _hospitalNameController;
  TextEditingController get doctorNameController => _doctorNameController;

  void setSelectedDepartmentIndex(int index) {
    _selectedDepartmentIndex = index;
  }

  int get selectedDepartmentIndex => _selectedDepartmentIndex;

  Future<void> searchDoctors() async {
    final String hospitalName = _hospitalNameController.text;
    final String doctorName = _doctorNameController.text;
    _doctorList = await _doctorApi.getDoctorList(
          doctorName: doctorName,
          hospitalName: hospitalName,
          departmentId:
              DepartmentData().data[_selectedDepartmentIndex].departmentName,
        ) ??
        [];
  }

  List<Doctor> get doctorList => _doctorList;
}
