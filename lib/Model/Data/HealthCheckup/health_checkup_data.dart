import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

import '../../Entity/HealthCheckUp/health_checkup.dart';

/// HealthCheckupDataを監視するProvider
final healthCheckupDataProvider =
    ChangeNotifierProvider((ref) => HealthCheckupData());

class HealthCheckupData extends ChangeNotifier {
  static final HealthCheckupData _instance = HealthCheckupData._internal();
  factory HealthCheckupData() => _instance;
  HealthCheckupData._internal();

  List<HealthCheckup> _data = [];

  List<HealthCheckup> get data => _data;

  /// リストごとデータをセット
  void setList(List<HealthCheckup> dataList) {
    _data = dataList;
    notifyListeners();
  }

  /// リストにデータを追加
  void addData(HealthCheckup data) {
    _data.add(data);
    notifyListeners();
  }

  /// リスト内のデータを更新する
  void updateData(HealthCheckup data) {
    try {
      final int index = _data.indexWhere(
          (element) => element.healthCheckupId == data.healthCheckupId);

      _data[index] = data;
      Log.echo('HealthCheckupData.updateData: ${data.toJson()}');
    } catch (e) {
      Log.echo('Error: $e');
    }

    notifyListeners();
  }
}
