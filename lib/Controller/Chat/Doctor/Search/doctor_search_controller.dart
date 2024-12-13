import 'dart:async';

import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Model/Data/Department/department_data.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';

import '../../../../Model/Cache/Doctor/PrimaryDoctors/primary_doctors_cache.dart';
import '../../../../Model/Entity/Department/department.dart';
import '../../../../Model/Entity/Doctor/doctor.dart';
import '../../../Core/controller_core.dart';

class DoctorSearchController extends ControllerCore {
  DoctorApi get _doctorApi => DoctorApi();

  DoctorSearchController({
    this.departmentId,
  });

  // テキストコントローラーの初期化
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _doctorNameController = TextEditingController();

  // 選択された科のインデックス(未選択はnull)
  late int? _selectedDepartmentIndex;
  late List<Department> _departmentList;

  // 医師情報画面からの検索条件
  final String? departmentId;

  @override
  void initialize() {
    _departmentList = DepartmentData().data;
    _selectedDepartmentIndex = null;

    if (departmentId != null) {
      // 初期選択科目がある場合は、その科目を選択状態にする
      _selectedDepartmentIndex = _departmentList
          .indexWhere((element) => element.departmentId == departmentId);
    }
  }

  // 科目リストのgetter
  List<Department> get departmentList => _departmentList;

  // テキストコントローラーのgetter
  TextEditingController get hospitalNameController => _hospitalNameController;
  TextEditingController get doctorNameController => _doctorNameController;

  // 科目が選択された際の処理
  void chaneDepartqmentIndex(int? index) {
    _selectedDepartmentIndex = index;
  }

  int? get selectedDepartmentIndex => _selectedDepartmentIndex;

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

  /// 主治医に登録している医者かどうかを判定する
  /// [doctorId] 医者ID
  bool isPrimaryDoctor(String doctorId) {
    List<String> doctorList = PrimaryDoctorsCache().data ?? [];
    return doctorList.contains(doctorId);
  }
}
