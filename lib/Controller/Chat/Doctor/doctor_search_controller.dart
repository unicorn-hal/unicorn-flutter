import 'dart:async';

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

  final StreamController<List<Doctor>> _doctorListController =
      StreamController.broadcast();

  // 1秒入力されなかったら検索を実行するためのタイマー
  Timer? _debounce;

  late int _selectedDepartmentIndex;
  late List<Department> _departmentList;
  List<Doctor> _doctorList = [];

  @override
  void initialize() {
    _departmentList = DepartmentData().data;
    _selectedDepartmentIndex = 0;

    // 1秒入力されなかったら検索を実行するリスナーを設定
    _hospitalNameController.addListener(() {
      _onSearchChanged();
    });
    _doctorNameController.addListener(() {
      _onSearchChanged();
    });

    //StreamControllerに初期値を流す
    _doctorListController.sink.add(_doctorList);
  }

  // 医師一覧のgetter
  List<Department> get departmentList => _departmentList;

  // テキストコントローラーのgetter
  TextEditingController get hospitalNameController => _hospitalNameController;
  TextEditingController get doctorNameController => _doctorNameController;

  // 1秒待ってから検索を実行する
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () async {
      await _searchDoctors();
    });
  }

  // 選択された科を設定したときに検索を実行する
  void setSelectedDepartmentIndex(int index) async {
    _selectedDepartmentIndex = index;
    _onSearchChanged();
  }

  int get selectedDepartmentIndex => _selectedDepartmentIndex;

  // 設定されたクエリで医師検索を実行する
  Future<void> _searchDoctors() async {
    final String hospitalName = _hospitalNameController.text;
    final String doctorName = _doctorNameController.text;
    _doctorList = await _doctorApi.getDoctorList(
          doctorName: doctorName,
          hospitalName: hospitalName,
          departmentId: _departmentList[_selectedDepartmentIndex].departmentId,
        ) ??
        [];

    _doctorListController.sink.add(_doctorList);
  }

  // 医師一覧のStream/getter
  Stream<List<Doctor>> get doctorListStream => _doctorListController.stream;
}
