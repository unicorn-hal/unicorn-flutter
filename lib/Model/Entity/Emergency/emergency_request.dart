class EmergencyRequest {
  final String userId;
  final String userLatitude;
  final String userLongitude;

  EmergencyRequest({
    required this.userId,
    required this.userLatitude,
    required this.userLongitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userId,
      'userLatitude': userLatitude,
      'userLongitude': userLongitude,
    };
  }

  factory EmergencyRequest.fromJson(Map<String, dynamic> json) {
    return EmergencyRequest(
      userId: json['userID'],
      userLatitude: json['userLatitude'],
      userLongitude: json['userLongitude'],
    );
  }
}
