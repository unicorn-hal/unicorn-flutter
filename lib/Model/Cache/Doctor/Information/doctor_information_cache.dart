import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';

class DoctorInformationCache {
  static final DoctorInformationCache _instance =
      DoctorInformationCache._internal();
  factory DoctorInformationCache() => _instance;
  DoctorInformationCache._internal();

  final List<Doctor> _data = [];

  List<Doctor> get data => _data;

  void addDoctor(Doctor data) {
    _data.add(data);
  }
}
