import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Model/Entity/Medicine/medicine.dart';

final medicineCacheProvider = ChangeNotifierProvider((ref) => MedicineCache());

class MedicineCache extends ChangeNotifier {
  static final MedicineCache _instance = MedicineCache._internal();
  factory MedicineCache() => _instance;
  MedicineCache._internal();

  final List<Medicine> _data = [];
  int _carouselIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();

  List<Medicine> get data => _data;
  int get carouselIndex => _carouselIndex;

  void setData(List<Medicine> dataList) {
    _data.clear();
    _data.addAll(dataList);
    notifyListeners();
  }

  void addData(Medicine data) {
    _data.add(data);
    notifyListeners();
  }

  void updateData(Medicine data) {
    final index =
        _data.indexWhere((element) => element.medicineId == data.medicineId);
    if (index != -1) {
      _data[index] = data;
      notifyListeners();
    }
  }

  void deleteData(String medicineId) {
    final index =
        _data.indexWhere((element) => element.medicineId == medicineId);
    if (index != -1) {
      _data.removeAt(index);
      notifyListeners();
    }
  }

  void setCarouselIndex(int index) {
    _carouselIndex = index;
    notifyListeners();
  }
}
