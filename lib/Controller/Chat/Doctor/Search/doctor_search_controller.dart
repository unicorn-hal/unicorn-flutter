import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Model/Data/Department/department_data.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';

import '../../../../Model/Entity/Department/department.dart';
import '../../../../Model/Entity/Doctor/doctor.dart';
import '../../../Core/controller_core.dart';

class DoctorSearchController extends ControllerCore {
  DoctorApi get _doctorApi => DoctorApi();

  DoctorSearchController();

  // テキストコントローラーの初期化
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();

  // 選択された科のインデックス(未選択はnull)
  late int? selectedDepartmentIndex;
  late List<Department> departmentList;

  @override
  void initialize() {
    departmentList = DepartmentData().data;
    selectedDepartmentIndex = null;
  }

  // テキストコントローラーのgetter
  TextEditingController get hospitalNameController => _hospitalNameController;
  TextEditingController get doctorNameController => _doctorNameController;

  // 設定されたクエリで医師検索を実行する
  Future<List<Doctor>> searchDoctors() async {
    final String hospitalName = _hospitalNameController.text;
    final String doctorName = _doctorNameController.text;
    return await _doctorApi.getDoctorList(
          doctorName: doctorName,
          hospitalName: hospitalName,
          departmentId: selectedDepartmentIndex != null
              ? departmentList[selectedDepartmentIndex!].departmentId
              : null,
        ) ??
        [];
  }
}
