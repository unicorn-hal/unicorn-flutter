import 'package:unicorn_flutter/Model/Entity/Hospital/hospital_news.dart';

class HospitalNewsCache {
  static final HospitalNewsCache _instance = HospitalNewsCache._internal();
  factory HospitalNewsCache() => _instance;
  HospitalNewsCache._internal();

  final List<HospitalNews> _data = [];

  List<HospitalNews> get data => _data;

  void setData(List<HospitalNews> dataList) {
    _data.clear();
    _data.addAll(dataList);
  }
}
