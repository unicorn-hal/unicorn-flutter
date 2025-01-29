import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_answer.dart';

class HealthCheckupQuestion {
  final bool isMainQuestion;
  final String question;
  final List<HealthCheckupDiseaseEnum>? diseaseType;
  final List<HealthCheckupAnswer>? answers;

  HealthCheckupQuestion({
    required this.question,
    required this.isMainQuestion,
    this.diseaseType,
    this.answers,
  });

  factory HealthCheckupQuestion.fromJson(Map<String, dynamic> json) {
    return HealthCheckupQuestion(
      question: json['question'],
      isMainQuestion: json['isMainQuestion'],
      diseaseType: json['diseaseType'],
      answers: json['answers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'isMainQuestion': isMainQuestion,
      'diseaseType': diseaseType,
      'answers': answers,
    };
  }

  HealthCheckupQuestion toRequest() {
    return HealthCheckupQuestion.fromJson(toJson());
  }
}
