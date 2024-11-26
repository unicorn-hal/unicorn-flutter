import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/health_checkup_question.dart';
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
    loadQuestionData();
  }

  /// 質問データの読み込み
  void loadQuestionData() {
    _checkupTitle = loadQuestionTitle();
    _checkupName = loadQuestionOptions();
    _checkupValue = initializeAnswerOptions();
  }

  /// 選択肢データの読み込み
  List<String> loadQuestionOptions() {
    /// 選択肢の初期化
    _checkupName.clear();

    /// 現在の質問を取得
    final currentQuestion = HealthCheckupQuestionData.questions[_questionCount];

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

  /// 質問データの読み込み
  String loadQuestionTitle() {
    final currentQuestion = HealthCheckupQuestionData.questions[_questionCount];
    return currentQuestion.question;
  }

  String get checkupTitle => _checkupTitle;

  /// 回答オプションの初期化
  List<bool> initializeAnswerOptions() {
    return _checkupValue = List.filled(_checkupName.length, false);
  }

  List<bool> get checkupValue => _checkupValue;

  /// 次の質問に移動
  /// [selectedIndex] 選択されたインデックス
  void nextQuestion(int selectedIndex) {
    if (_questionCount >= HealthCheckupQuestionData.questions.length - 1) {
      ProgressRoute(
        healthPoint: _healthPoint,
        diseaseType: _diseaseType,
      ).go(context);
      return;
    }

    /// メイン質問かどうかで分岐
    /// メイン質問の場合は病気タイプを取得
    /// それ以外は健康ポイントを取得
    if (HealthCheckupQuestionData.questions[_questionCount].isMainQuestion) {
      _diseaseType = getDiseaseType(selectedIndex);
    } else {
      _healthPoint = updateHealthPoint(selectedIndex);
    }

    _questionCount++;
    loadQuestionData();
    _progressText = updateProgressText();
  }

  /// 健康ポイントを更新
  /// [selectedIndex] 選択されたインデックス
  int updateHealthPoint(int selectedIndex) {
    /// 選択されたインデックスの健康ポイントを取得
    return _healthPoint += HealthCheckupQuestionData
        .questions[_questionCount].answers![selectedIndex].healthPoint;
  }

  int get healthPoint => _healthPoint;

  /// 選択したインデックスから病気タイプを取得
  /// [selectedIndex] 選択されたインデックス
  HealthCheckupDiseaseEnum getDiseaseType(int selectedIndex) {
    /// 選択されたインデックスの病気タイプを取得
    return _diseaseType = HealthCheckupQuestionData
        .questions[_questionCount].diseaseType![selectedIndex];
  }

  HealthCheckupDiseaseEnum get diseaseType => _diseaseType;

  /// プログレスバーの更新
  String updateProgressText() {
    _progressValue = updateProgressValue();
    return _progressText = '${(_progressValue * 100).toStringAsFixed(0)}%';
  }

  /// プログレスバーの値を更新
  double updateProgressValue() {
    return _progressValue += 0.1;
  }

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
