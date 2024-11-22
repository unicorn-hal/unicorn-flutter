class AgoraCertificateRequest {
  final String channelName;
  final String uid;

  AgoraCertificateRequest({
    required this.channelName,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'channelName': channelName,
      'uid': uid,
    };
  }

  factory AgoraCertificateRequest.fromJson(Map<String, dynamic> json) {
    return AgoraCertificateRequest(
      channelName: json['channelName'],
      uid: json['uid'],
    );
  }
}
