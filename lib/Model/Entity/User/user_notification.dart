class UserNotification {
  final bool isMedicineReminder;
  final bool isRegularHealthCheckup;
  final bool isHospitalNews;

  UserNotification({
    required this.isMedicineReminder,
    required this.isRegularHealthCheckup,
    required this.isHospitalNews,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      isMedicineReminder: json['isMedicineReminder'],
      isRegularHealthCheckup: json['isRegularHealthCheckup'],
      isHospitalNews: json['isHospitalNews'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isMedicineReminder': isMedicineReminder,
      'isRegularHealthCheckup': isRegularHealthCheckup,
      'isHospitalNews': isHospitalNews,
    };
  }
}
