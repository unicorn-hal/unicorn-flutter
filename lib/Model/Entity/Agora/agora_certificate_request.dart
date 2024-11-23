class AgoraCertificateRequest {
  final String channelName;

  AgoraCertificateRequest({
    required this.channelName,
  });

  Map<String, dynamic> toJson() {
    return {
      'channelName': channelName,
    };
  }

  factory AgoraCertificateRequest.fromJson(Map<String, dynamic> json) {
    return AgoraCertificateRequest(
      channelName: json['channelName'],
    );
  }
}
