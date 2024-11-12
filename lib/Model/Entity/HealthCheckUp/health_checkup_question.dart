import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Model/Entity/HealthCheckUp/health_checkup_anser.dart';

class HealthCheckupQuestion {
  final int number;
  final bool isMainQuestion;
  final String question;
  final List<HealthCheckupDiseaseEnum>? diseaseType;
  final List<HealthCheckupAnswer>? answers;

  HealthCheckupQuestion({
    required this.number,
    required this.question,
    required this.isMainQuestion,
    this.diseaseType,
    this.answers,
  });

  factory HealthCheckupQuestion.fromJson(Map<String, dynamic> json) {
    return HealthCheckupQuestion(
      number: json['number'],
      question: json['question'],
      isMainQuestion: json['isMainQuestion'],
      diseaseType: json['diseaseType'],
      answers: json['answers'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
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
