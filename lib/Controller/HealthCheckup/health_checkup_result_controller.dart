import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/Enum/day_of_week_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/Enum/health_risk_level_enum.dart';
import 'package:unicorn_flutter/Constants/disease_example_name_list.dart';
import 'package:unicorn_flutter/Constants/disease_text_list.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/Account/account_data.dart';
import 'package:unicorn_flutter/Model/Entity/User/user.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';

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

  /// ユーザー名を取得
  Future<String?> getUserName() async {
    User? user = await UserApi().getUser(userId: AccountData().account!.uid);
    if (user == null) {
      return null;
    }
    return '${user.lastName} ${user.firstName}';
  }

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
  void setHealthRiskLevelView(HealthRiskLevelEnum healthRiskLevel) {
    switch (healthRiskLevel) {
      case HealthRiskLevelEnum.high:
        _healthText = Strings.HEALTH_CHECKUP_RESULT_RISK_LEVEL_HIGH;
        _healthColor = Colors.red;
        break;
      case HealthRiskLevelEnum.medium:
        _healthText = Strings.HEALTH_CHECKUP_RESULT_RISK_LEVEL_MEDIUM;
        _healthColor = Colors.orange;
        break;
      case HealthRiskLevelEnum.low:
        _healthText = Strings.HEALTH_CHECKUP_RESULT_RISK_LEVEL_LOW;
        _healthColor = Colors.blue;
        break;
    }
  }

  Color get healthColor => _healthColor;

  String get healthText => _healthText;

  /// 疾患タイプに応じたテキストリストと疾患例名リストを設定
  void setDiseaseTypeView(HealthCheckupDiseaseEnum diseaseType) {
    switch (diseaseType) {
      case HealthCheckupDiseaseEnum.goodHealth:
        _diseaseTextList = DiseaseTextList.goodHealthTextList;
        _diseaseExampleNameList =
            DiseaseExampleNameList.goodHealthExampleNameList;
        break;
      case HealthCheckupDiseaseEnum.highFever:
        _diseaseTextList = DiseaseTextList.highFeverTextList;
        _diseaseExampleNameList =
            DiseaseExampleNameList.highFeverExampleNameList;
        break;
      case HealthCheckupDiseaseEnum.badFeel:
        _diseaseTextList = DiseaseTextList.badFeelTextList;
        _diseaseExampleNameList = DiseaseExampleNameList.badFeelExampleNameList;
        break;
      case HealthCheckupDiseaseEnum.painfulChest:
        _diseaseTextList = DiseaseTextList.painfulChestTextList;
        _diseaseExampleNameList =
            DiseaseExampleNameList.painfulChestExampleNameList;
        break;
      case HealthCheckupDiseaseEnum.painfulStomach:
        _diseaseTextList = DiseaseTextList.painfulStomachTextList;
        _diseaseExampleNameList =
            DiseaseExampleNameList.painfulStomachExampleNameList;
        break;
      case HealthCheckupDiseaseEnum.painfulHead:
        _diseaseTextList = DiseaseTextList.painfulHeadTextList;
        _diseaseExampleNameList =
            DiseaseExampleNameList.painfulHeadExampleNameList;
        break;
    }
  }

  List<String> get diseaseTextList => _diseaseTextList;

  List<String> get diseaseExampleNameList => _diseaseExampleNameList;
}
