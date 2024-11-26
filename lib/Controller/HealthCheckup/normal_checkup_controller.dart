import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/health_checkup_questions.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Route/router.dart';

class NormalCheckupController extends ControllerCore {
  BuildContext context;
  NormalCheckupController(this.context);

  int _questionCount = 0;
  int _healthPoint = 0;
  List<String> _checkupName = [];
  double _progressValue = 0.0;
  String _progressText = '0%';

  late String _checkupTitle;
  late List<bool> _checkupValue;
  late HealthCheckupDiseaseEnum _diseaseType;

  /// 初期化
  @override
  void initialize() {
    _loadQuestionData();
  }

  /// 質問データの読み込み
  void _loadQuestionData() {
    _checkupTitle = HealthCheckupQuestions.dataList[_questionCount].question;
    _checkupValue = List.filled(_checkupName.length, false);
    _checkupName = _loadQuestionOptions();
  }

  /// 選択肢データの読み込み
  List<String> _loadQuestionOptions() {
    /// 選択肢の初期化
    _checkupName.clear();

    /// 現在の質問を取得
    final currentQuestion = HealthCheckupQuestions.dataList[_questionCount];

    /// メイン質問かどうかで分岐
    /// メイン質問の場合は病気タイプを取得
    /// それ以外は回答を取得
    if (currentQuestion.isMainQuestion) {
      _checkupName = currentQuestion.diseaseType!
          .map((type) => HealthCheckupDiseaseType.toStringValue(type))
          .toList();
    } else {
      _checkupName =
          currentQuestion.answers!.map((answer) => answer.answer).toList();
    }
    return _checkupName;
  }

  List<String> get checkupName => _checkupName;

  String get checkupTitle => _checkupTitle;

  List<bool> get checkupValue => _checkupValue;

  /// 次の質問に移動
  /// [selectedIndex] 選択されたインデックス
  void nextQuestion(int selectedIndex) {
    if (_questionCount >= HealthCheckupQuestions.dataList.length - 1) {
      ProgressRoute(
        healthPoint: _healthPoint,
        diseaseType: _diseaseType,
      ).go(context);
      return;
    }

    /// メイン質問かどうかで分岐
    /// メイン質問の場合は病気タイプを取得
    /// それ以外は健康ポイントを取得
    if (HealthCheckupQuestions.dataList[_questionCount].isMainQuestion) {
      _diseaseType = HealthCheckupQuestions
          .dataList[_questionCount].diseaseType![selectedIndex];
    } else {
      _healthPoint += HealthCheckupQuestions
          .dataList[_questionCount].answers![selectedIndex].healthPoint;
    }

    _questionCount++;
    _loadQuestionData();

    /// プログレスバーの更新
    _progressText = '${((_progressValue += 0.1) * 100).toStringAsFixed(0)}%';
  }

  int get healthPoint => _healthPoint;

  HealthCheckupDiseaseEnum get diseaseType => _diseaseType;

  double get progressValue => _progressValue;

  String get progressText => _progressText;

  /// チェックボックスの選択を更新（ラジオボタンのように一つだけを選択）
  /// [selectedIndex] 選択されたインデックス]
  void updateCheckupValue(int selectedIndex) {
    for (int i = 0; i < _checkupValue.length; i++) {
      _checkupValue[i] = (i == selectedIndex);
    }
  }
}
