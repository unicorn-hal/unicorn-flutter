class AppConfig {
  final bool available;

  AppConfig({
    required this.available,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      available: json['available'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
    };
  }
}
