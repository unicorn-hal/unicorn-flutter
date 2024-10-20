enum UserGenderEnum {
  male,
  female,
  other,
}

class UserGenderType {
  static UserGenderEnum fromString(String value) {
    switch (value) {
      case 'male':
        return UserGenderEnum.male;
      case 'female':
        return UserGenderEnum.female;
      case 'other':
        return UserGenderEnum.other;
      default:
        throw Exception('Unknown type: $value');
    }
  }

  static String toStringValue(UserGenderEnum value) {
    switch (value) {
      case UserGenderEnum.male:
        return 'male';
      case UserGenderEnum.female:
        return 'female';
      case UserGenderEnum.other:
        return 'other';
      default:
        throw Exception('Unknown type: $value');
    }
  }
}
