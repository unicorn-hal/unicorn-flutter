import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Entity/HealthCheckUp/health_checkup.dart';

/// HealthCheckupDataを監視するProvider
final healthCheckupDataProvider =
    ChangeNotifierProvider((ref) => HealthCheckupData());

class HealthCheckupData extends ChangeNotifier {
  static final HealthCheckupData _instance = HealthCheckupData._internal();
  factory HealthCheckupData() => _instance;
  HealthCheckupData._internal();

  List<HealthCheckup>? _data;

  List<HealthCheckup>? get data => _data;

  /// リストごとデータをセット
  void setList(List<HealthCheckup> dataList) {
    _data = dataList;
  }

  /// リストにデータを追加
  void addList(HealthCheckup data) {
    _data?.add(data);
  }
}
