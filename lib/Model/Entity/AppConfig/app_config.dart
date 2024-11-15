class AppConfig {
  final bool available;
  final String stunServerType;

  AppConfig({
    required this.available,
    required this.stunServerType,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      available: json['available'],
      stunServerType: json['stunServerType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available': available,
      'stunServerType': stunServerType,
    };
  }
}
