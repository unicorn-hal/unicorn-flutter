enum UserRoleEnum {
  user,
  doctor,
}

class UserRoleType {
  static UserRoleEnum fromString(String value) {
    switch (value) {
      case 'user':
        return UserRoleEnum.user;
      case 'doctor':
        return UserRoleEnum.doctor;
      default:
        throw Exception('Unknown type: $value');
    }
  }

  static String toStringValue(UserRoleEnum value) {
    switch (value) {
      case UserRoleEnum.user:
        return 'user';
      case UserRoleEnum.doctor:
        return 'doctor';
      default:
        throw Exception('Unknown type: $value');
    }
  }
}
