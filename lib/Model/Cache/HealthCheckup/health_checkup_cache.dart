import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';

import '../../Entity/HealthCheckUp/health_checkup.dart';

/// HealthCheckupDataを監視するProvider
final healthCheckupCacheProvider =
    ChangeNotifierProvider((ref) => HealthCheckupCache());

class HealthCheckupCache extends ChangeNotifier {
  static final HealthCheckupCache _instance = HealthCheckupCache._internal();
  factory HealthCheckupCache() => _instance;
  HealthCheckupCache._internal();

  final List<HealthCheckup> _data = [];
  List<HealthCheckup> get data => _data;

  /// リストごとデータをセット
  void setData(List<HealthCheckup> dataList) {
    _data.clear();
    _data.addAll(dataList);
    notifyListeners();
  }

  /// リストにデータを追加
  void addData(HealthCheckup data) {
    _data.add(data);
    notifyListeners();
  }

  /// 今日のデータを取得
  HealthCheckup? getTodayData() {
    try {
      final DateTime now = DateTime.now();
      return _data.firstWhere(
        (element) =>
            element.date.year == now.year &&
            element.date.month == now.month &&
            element.date.day == now.day,
      );
    } catch (e) {
      Log.echo('Error: $e');
      return null;
    }
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
