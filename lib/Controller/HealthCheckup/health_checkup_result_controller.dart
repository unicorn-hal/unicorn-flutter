import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/day_of_week_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/health_risk_level_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Service/Package/UrlLauncher/url_launcher_service.dart';

class HealthCheckupResultController extends ControllerCore {
  /// Serviceのインスタンス化

  /// コンストラクタ
  HealthCheckupResultController(
    this.context,
    this.diseaseType,
    this.healthPoint,
    this.bloodPressure,
    this.bodyTemperature,
  );
  BuildContext context;

  /// 変数の定義
  /// リスクレベルの閾値
  int dangerLine = 6;
  int deadLine = 10;

  int healthPoint;
  HealthCheckupDiseaseEnum diseaseType;
  String bloodPressure;
  String bodyTemperature;
  late String _formattedDate;
  late Color _healthColor;
  late String userName;
  late String _healthText;
  late List<String> _diseaseTextList;
  late List<String> _diseaseExampleNameList;

  /// initialize()
  @override
  void initialize() {
    _formattedDate = getTodayDate();
    setHealthRiskLevelView(getHealthRiskLevel());
    setDiseaseTypeView(diseaseType);
  }

  /// 各関数の実装
  /// 本日の日付を取得
  String getTodayDate() {
    DateTime today = DateTime.now();

    /// 本日の日付を取得(2024-11-06の形式)
    String todayDatePart = DateFormat('MM/dd').format(today);

    /// 本日の曜日を取得
    String todayDayOfWeek = DateFormat('EEEE').format(today).toLowerCase();
    DayOfWeekEnum dayOfWeekEnum = DayOfWeekEnumType.fromString(todayDayOfWeek);
    String formattedDayOfWeek =
        DayOfWeekEnumType.toJapanseString(dayOfWeekEnum);
    _formattedDate = '$todayDatePart($formattedDayOfWeek)';
    return _formattedDate;
  }

  String get formattedDate => _formattedDate;

  /// 健康リスクレベルを取得
  HealthRiskLevelEnum getHealthRiskLevel() {
    if (healthPoint > deadLine) {
      return HealthRiskLevelEnum.high;
    } else if (healthPoint > dangerLine) {
      return HealthRiskLevelEnum.medium;
    } else {
      return HealthRiskLevelEnum.low;
    }
  }

  /// 健康リスクレベルに応じたテキストとカラーを設定
  /// [healthRiskLevel] 健康リスクレベル
  void setHealthRiskLevelView(HealthRiskLevelEnum healthRiskLevel) {
    _healthText = HealthRiskLevelType.getHealthRiskLevelString(healthRiskLevel);
    _healthColor = HealthRiskLevelType.getHealthRiskLevelColor(healthRiskLevel);
  }

  Color get healthColor => _healthColor;

  String get healthText => _healthText;

  /// 疾患タイプに応じたテキストリストと疾患例名リストを設定
  /// [diseaseType] 疾患タイプ
  void setDiseaseTypeView(HealthCheckupDiseaseEnum diseaseType) {
    _diseaseTextList = HealthCheckupDiseaseType.getDiseaseTextList(diseaseType);
    _diseaseExampleNameList =
        HealthCheckupDiseaseType.getDiseaseExampleNameList(diseaseType);
  }

  List<String> get diseaseTextList => _diseaseTextList;

  List<String> get diseaseExampleNameList => _diseaseExampleNameList;

  /// 疾患名をクリックした際の処理
  /// 疾患名をクリックするとWikipediaのページに遷移
  /// [diseaseName] 疾患名
  Future<void> getDiseaseUrl(String diseaseName) {
    return UrlLauncherService()
        .launchUrl('https://ja.wikipedia.org/wiki/$diseaseName');
  }
}
