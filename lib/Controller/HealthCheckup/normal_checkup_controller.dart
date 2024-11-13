import 'package:flutter/material.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Constants/health_checkup_question.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Route/router.dart';

class NormalCheckupController extends ControllerCore {
  final BuildContext context;
  NormalCheckupController(this.context);

  // 質問の進行状態とポイントの管理
  int questionCount = 0;
  int healthPoint = 0;

  // チェックアップ情報
  String checkupTitle = '';
  List<String> checkupName = [];
  List<bool> checkupValue = [];

  // プログレス状態
  double progressValue = 0.0;
  String progressText = '0%';

  late HealthCheckupDiseaseEnum diseaseType;

  @override
  void initialize() {
    print('Controller Init');
    loadQuestionData();
  }

  /// 質問データの読み込み
  void loadQuestionData() {
    checkupTitle = HealthCheckupQuestionData.questions[questionCount].question;
    loadQuestionOptions();
    initializeAnswerOptions();
  }

  /// 選択肢データの読み込み
  void loadQuestionOptions() {
    checkupName.clear();
    final currentQuestion = HealthCheckupQuestionData.questions[questionCount];
    if (currentQuestion.isMainQuestion) {
      checkupName = currentQuestion.diseaseType!
          .map((type) => HealthCheckupDiseaseType.toStringValue(type))
          .toList();
    } else {
      checkupName =
          currentQuestion.answers!.map((answer) => answer.answer).toList();
    }
    print("Options: $checkupName");
  }

  /// 回答オプションの初期化
  void initializeAnswerOptions() {
    checkupValue = List.filled(checkupName.length, false);
  }

  /// チェックボックスの選択を更新（ラジオボタンのように一つだけを選択）
  void updateCheckupValue(int selectedIndex) {
    for (int i = 0; i < checkupValue.length; i++) {
      checkupValue[i] = (i == selectedIndex);
    }
  }

  /// プログレスバーの更新
  void updateProgressValue() {
    progressValue += 0.1;
    progressText = '${(progressValue * 100).toStringAsFixed(0)}%';
  }

  /// 選択したインデックスから病気タイプを取得
  void getDiseaseType(int selectedIndex) {
    diseaseType = HealthCheckupQuestionData
        .questions[questionCount].diseaseType![selectedIndex];
  }

  /// 健康ポイントを更新
  void updateHealthPoint(int selectedIndex) {
    healthPoint += HealthCheckupQuestionData
        .questions[questionCount].answers![selectedIndex].healthPoint;
  }

  /// 次の質問に移動
  void nextQuestion(int selectedIndex) {
    if (questionCount >= HealthCheckupQuestionData.questions.length - 1) {
      // 質問が終わったら結果画面へ移動
      const CheckupResultRoute().push(context);
      return;
    }

    if (HealthCheckupQuestionData.questions[questionCount].isMainQuestion) {
      getDiseaseType(selectedIndex);
      print("Disease Type: $diseaseType");
    } else {
      updateHealthPoint(selectedIndex);
      print("Health Point: $healthPoint");
    }

    questionCount++;
    loadQuestionData();
    updateProgressValue();
  }
}
