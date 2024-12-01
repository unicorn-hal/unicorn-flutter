import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/day_of_week_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/health_risk_level_enum.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/HealthCheckup/health_checkup_data.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_request.dart';
import 'package:unicorn_flutter/Service/Api/HealthCheckup/health_checkup_api.dart';
import 'package:unicorn_flutter/Service/Package/UrlLauncher/url_launcher_service.dart';

import '../../../Model/Entity/HealthCheckUp/health_checkup.dart';
import '../../../Service/Api/User/user_api.dart';

class HealthCheckupResultsController extends ControllerCore {
  /// Serviceのインスタンス化
  UserApi get _userApi => UserApi();
  HealthCheckupApi get _healthCheckupApi => HealthCheckupApi();
  UrlLauncherService get _urlLauncherService => UrlLauncherService();

  /// コンストラクタ
  HealthCheckupResultsController({
    required this.context,
    required this.bloodPressure,
    required this.bodyTemperature,
    required this.healthPoint,
    required this.diseaseType,
  });

  BuildContext context;
  int healthPoint;
  HealthCheckupDiseaseEnum diseaseType;
  String bloodPressure;
  String bodyTemperature;

  /// 変数の定義
  /// リスクレベルの閾値
  final int _dangerLine = 6;
  final int _deadLine = 10;

  late String _formattedDate;
  late Color _healthColor;
  late String _healthText;
  late List<String> _diseaseTextList;
  late List<String> _diseaseExampleNameList;

  /// initialize()
  @override
  void initialize() {
    /// 本日の日付を取得
    DateTime today = DateTime.now();
    _formattedDate = _getTodayDate(today);

    /// 健康リスクレベルを取得
    /// リスクレベルに応じたテキストとカラーを設定
    /// リスクレベルに応じた疾患タイプのテキストリストと疾患例名リストを設定
    _healthText =
        HealthRiskLevelType.getHealthRiskLevelString(_getHealthRiskLevel());
    _healthColor =
        HealthRiskLevelType.getHealthRiskLevelColor(_getHealthRiskLevel());

    /// 疾患タイプに応じたテキストリストと疾患例名リストを設定
    /// 疾患タイプに応じたテキストリストと疾患例名リストを取得
    _diseaseTextList = HealthCheckupDiseaseType.getDiseaseTextList(diseaseType);
    _diseaseExampleNameList =
        HealthCheckupDiseaseType.getDiseaseExampleNameList(diseaseType);

    _postHealthCheckup(today);
  }

  /// 各関数の実装
  /// 本日の日付を取得
  String _getTodayDate(DateTime date) {
    /// 本日の日付を取得(2024-11-06の形式)
    String todayDatePart = DateFormat('MM/dd').format(date);

    /// 本日の曜日を取得
    String todayDayOfWeek = DateFormat('EEEE').format(date).toLowerCase();
    DayOfWeekEnum dayOfWeekEnum = DayOfWeekEnumType.fromString(todayDayOfWeek);
    String formattedDayOfWeek =
        DayOfWeekEnumType.toDayAbbreviation(dayOfWeekEnum);
    return '$todayDatePart($formattedDayOfWeek)';
  }

  /// postに必要なデータを整形
  /// [bodyTemperature] 体温
  /// [bloodPressure] 血圧
  HealthCheckupRequest _makeHealthCheckupRequest(
    String bodyTemperature,
    String bloodPressure,
    DateTime today,
  ) {
    String date = DateFormat('yyyy年MM月dd日').format(today);
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
      date: DateFormat('yyyy-MM-dd').parse(today.toString()),
      bodyTemperature: double.parse(bodyTemperature),
      bloodPressure: bloodPressure,
      medicalRecord: medicalRecord,
    );
  }

  /// post処理
  Future<void> _postHealthCheckup(DateTime today) async {
    /// postに必要なデータを整形
    HealthCheckupRequest healthCheckupRequest = _makeHealthCheckupRequest(
      bodyTemperature,
      bloodPressure,
      today,
    );

    // postするものと同じ日付のHealthCheckupがあるかを確認
    String? healthCheckupId =
        getHealthCheckupIdWithDate(healthCheckupRequest.date);
    HealthCheckup? response;

    // その日付のHealthCheckupがあれば更新、なければ新規作成
    if (healthCheckupId != null) {
      response = await _userApi.putUserHealthCheckup(
        userId: UserData().user!.userId,
        healthCheckupId: healthCheckupId,
        body: healthCheckupRequest,
      );

      if (response == null) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        return;
      }

      //成功時にはHealthCheckupDataにあるデータを更新
      HealthCheckupData().updateData(response);
    } else {
      response =
          await _healthCheckupApi.postHealthCheckup(body: healthCheckupRequest);

      if (response == null) {
        Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
        return;
      }
      //成功時にはHealthCheckupDataに値を追加
      HealthCheckupData().addData(response);
    }
  }

  String get formattedDate => _formattedDate;

  /// 健康リスクレベルを取得
  HealthRiskLevelEnum _getHealthRiskLevel() {
    if (healthPoint > _deadLine) {
      return HealthRiskLevelEnum.high;
    } else if (healthPoint > _dangerLine) {
      return HealthRiskLevelEnum.medium;
    } else {
      return HealthRiskLevelEnum.low;
    }
  }

  Color get healthColor => _healthColor;

  String get healthText => _healthText;

  List<String> get diseaseTextList => _diseaseTextList;

  List<String> get diseaseExampleNameList => _diseaseExampleNameList;

  /// 疾患名をクリックした際の処理
  /// 疾患名をクリックするとWikipediaのページに遷移
  /// [diseaseName] 疾患名
  Future<void> getDiseaseUrl(String diseaseName) {
    return _urlLauncherService
        .launchUrl('https://ja.wikipedia.org/wiki/$diseaseName');
  }

  /// 日付を指定してその日付のHealthCheckupが存在すればhealthcheckupIdを返す
  /// [date] 日付
  String? getHealthCheckupIdWithDate(DateTime date) {
    List<HealthCheckup> healthCheckupList = HealthCheckupData().data ?? [];
    for (HealthCheckup healthCheckup in healthCheckupList) {
      if (healthCheckup.date == date) {
        return healthCheckup.healthCheckupId;
      }
    }
    return null;
  }
}
