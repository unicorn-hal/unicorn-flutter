enum FCMTopicEnum {
  all,
  user,
  doctor,
  regularHealthCheckup,
  hospitalNews,
}

class FCMTopicType {
  static FCMTopicEnum fromString(String value) {
    switch (value) {
      case 'all':
        return FCMTopicEnum.all;
      case 'user':
        return FCMTopicEnum.user;
      case 'doctor':
        return FCMTopicEnum.doctor;
      default:
        throw Exception('Unknown type: $value');
    }
  }

  static String toStringValue(FCMTopicEnum value) {
    switch (value) {
      case FCMTopicEnum.all:
        return 'all';
      case FCMTopicEnum.user:
        return 'user';
      case FCMTopicEnum.doctor:
        return 'doctor';
      case FCMTopicEnum.regularHealthCheckup:
        return 'regularHealthCheckup';
      case FCMTopicEnum.hospitalNews:
        return 'hospitalNews';
      default:
        throw Exception('Unknown type: $value');
    }
  }
}
