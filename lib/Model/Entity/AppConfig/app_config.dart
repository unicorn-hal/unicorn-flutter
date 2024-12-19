class AppConfig {
  final bool available;
  final int releaseBuild;
  final bool demoMode;

  AppConfig({
    this.available = false,
    this.releaseBuild = 8,
    this.demoMode = true,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      available: json['available'],
      releaseBuild: json['releaseBuild'],
      demoMode: json['demoMode'],
    );
  }
}
