class AgoraCertificate {
  final String token;

  AgoraCertificate({required this.token});

  factory AgoraCertificate.fromJson(Map<String, dynamic> json) {
    return AgoraCertificate(
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
