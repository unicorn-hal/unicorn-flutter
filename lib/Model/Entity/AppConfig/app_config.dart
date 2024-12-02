class AppConfig {
  final bool available;
  final int releaseBuild;

  AppConfig({
    required this.available,
    required this.releaseBuild,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      available: json['available'],
      releaseBuild: json['releaseBuild'],
    );
  }
}
