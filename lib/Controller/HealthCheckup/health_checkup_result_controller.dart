import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/day_of_week_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/health_risk_level_enum.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_request.dart';
import 'package:unicorn_flutter/Service/Api/HealthCheckup/health_checkup_api.dart';
import 'package:unicorn_flutter/Service/Package/UrlLauncher/url_launcher_service.dart';

class HealthCheckupResultController extends ControllerCore {
  /// Serviceのインスタンス化
  HealthCheckupApi get _healthCheckupApi => HealthCheckupApi();
  UrlLauncherService get _urlLauncherService => UrlLauncherService();

  /// コンストラクタ
  HealthCheckupResultController({
    required this.context,
    required this.bloodPressure,
    required this.bodyTemperature,
    required this.healthPoint,
    required this.diseaseType,
  });
  BuildContext context;

  /// 変数の定義
  /// リスクレベルの閾値
  final int _dangerLine = 6;
  final int _deadLine = 10;

  int healthPoint;
  HealthCheckupDiseaseEnum diseaseType;
  String bloodPressure;
  String bodyTemperature;
  late String _formattedDate;
  late HealthCheckupRequest _healthCheckupRequest;
  late Color _healthColor;
  late String userName;
  late String _healthText;
  late List<String> _diseaseTextList;
  late List<String> _diseaseExampleNameList;

  /// initialize()
  @override
  void initialize() {
    /// 本日の日付を取得
    _formattedDate = getTodayDate();

    /// 健康リスクレベルを取得
    setHealthRiskLevelView(getHealthRiskLevel());

    /// 疾患タイプに応じたテキストリストと疾患例名リストを設定
    setDiseaseTypeView(diseaseType);

    /// postに必要なデータを整形
    _healthCheckupRequest = formatHealthCheckupRecordless(
      bodyTemperature,
      bloodPressure,
    );

    /// post処理
    postHealthCheckup(_healthCheckupRequest);
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
        DayOfWeekEnumType.toDayAbbreviation(dayOfWeekEnum);
    _formattedDate = '$todayDatePart($formattedDayOfWeek)';
    return _formattedDate;
  }

  /// postに必要なデータを整形
  /// [bodyTemperature] 体温
  /// [bloodPressure] 血圧
  HealthCheckupRequest formatHealthCheckupRecordless(
    String bodyTemperature,
    String bloodPressure,
  ) {
    String date = DateFormat('yyyy年MM月dd日').format(DateTime.now());
    String diseaseExampleName;

    /// 疾患例名を取得
    if (diseaseType == HealthCheckupDiseaseEnum.goodHealth) {
      /// 疾患例名が健康の場合は健康と表示
      /// それ以外は疾患例名リストの先頭を取得
      diseaseExampleName = '健康';
    } else {
      diseaseExampleName = diseaseExampleNameList[0];
    }

    /// 診断書のテキストを作成
    String medicalRecord =
        '## $date\n 体温: bloodPressure\n 血圧: bodyTemperature\n 診断: 軽度の$diseaseExampleName';
    return HealthCheckupRequest(
      date: DateFormat('yyyy-MM-dd').parse(DateTime.now().toString()),
      bodyTemperature: double.parse(bodyTemperature),
      bloodPressure: bloodPressure,
      medicalRecord: medicalRecord,
    );
  }

  /// post処理
  /// [healthCheckupRequest] 健康診断リクエスト
  Future<int> postHealthCheckup(
      HealthCheckupRequest healthCheckupRequest) async {
    int res =
        await _healthCheckupApi.postHealthCheckup(body: healthCheckupRequest);
    if (res != 200) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    return res;
  }

  String get formattedDate => _formattedDate;

  /// 健康リスクレベルを取得
  HealthRiskLevelEnum getHealthRiskLevel() {
    if (healthPoint > _deadLine) {
      return HealthRiskLevelEnum.high;
    } else if (healthPoint > _dangerLine) {
      return HealthRiskLevelEnum.medium;
    } else {
      return HealthRiskLevelEnum.low;
    }
  }

  /// 健康リスクレベルに応じたテキストとカラーを設定
  /// [healthRiskLevel] 健康リスクレベル
  void setHealthRiskLevelView(HealthRiskLevelEnum healthRiskLevel) {
    /// 健康リスクレベルに応じたテキストとカラーを取得
    _healthText = HealthRiskLevelType.getHealthRiskLevelString(healthRiskLevel);
    _healthColor = HealthRiskLevelType.getHealthRiskLevelColor(healthRiskLevel);
  }

  Color get healthColor => _healthColor;

  String get healthText => _healthText;

  /// 疾患タイプに応じたテキストリストと疾患例名リストを設定
  /// [diseaseType] 疾患タイプ
  void setDiseaseTypeView(HealthCheckupDiseaseEnum diseaseType) {
    /// 疾患タイプに応じたテキストリストと疾患例名リストを取得
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
    return _urlLauncherService
        .launchUrl('https://ja.wikipedia.org/wiki/$diseaseName');
  }
}
