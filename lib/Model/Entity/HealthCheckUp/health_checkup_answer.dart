class HealthCheckupAnswer {
  final String answer;
  final int healthPoint;

  HealthCheckupAnswer({
    required this.answer,
    required this.healthPoint,
  });

  factory HealthCheckupAnswer.fromJson(Map<String, dynamic> json) {
    return HealthCheckupAnswer(
      answer: json['answer'],
      healthPoint: json['healthPoint'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer': answer,
      'healthPoint': healthPoint,
    };
  }

  HealthCheckupAnswer toRequest() {
    return HealthCheckupAnswer.fromJson(toJson());
  }
}
