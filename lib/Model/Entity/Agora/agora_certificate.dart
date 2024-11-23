class AgoraCertificate {
  final int uid;
  final String token;

  AgoraCertificate({required this.uid, required this.token});

  factory AgoraCertificate.fromJson(Map<String, dynamic> json) {
    return AgoraCertificate(
      uid: json['uid'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'token': token,
    };
  }
}
