import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';

final medicineCacheProvider = ChangeNotifierProvider((ref) => MedicineCache());

class MedicineCache extends ChangeNotifier {
  static final MedicineCache _instance = MedicineCache._internal();
  factory MedicineCache() => _instance;
  MedicineCache._internal();

  final List<Medicine> _data = [];

  List<Medicine> get data => _data;

  void setList(List<Medicine> dataList) {
    _data.clear();
    _data.addAll(dataList);
    notifyListeners();
  }

  void addMedicine(Medicine data) {
    _data.add(data);
    notifyListeners();
  }

  void updateMedicine(Medicine data) {
    final index =
        _data.indexWhere((element) => element.medicineId == data.medicineId);
    if (index != -1) {
      _data[index] = data;
      notifyListeners();
    }
  }

  void deleteMedicine(String medicineId) {
    final index =
        _data.indexWhere((element) => element.medicineId == medicineId);
    if (index != -1) {
      _data.removeAt(index);
      notifyListeners();
    }
  }
}
