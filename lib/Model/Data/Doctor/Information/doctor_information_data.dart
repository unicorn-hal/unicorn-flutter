import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';

class DoctorInformationData {
  static final DoctorInformationData _instance =
      DoctorInformationData._internal();
  factory DoctorInformationData() => _instance;
  DoctorInformationData._internal();

  final List<Doctor> _data = [];

  List<Doctor> get data => _data;

  void addDoctor(Doctor data) {
    _data.add(data);
  }
}
