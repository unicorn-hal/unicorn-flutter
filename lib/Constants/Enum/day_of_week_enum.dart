enum DayOfWeekEnum {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class DayOfWeekEnumType {
  static DayOfWeekEnum fromString(String value) {
    switch (value) {
      case 'monday':
        return DayOfWeekEnum.monday;
      case 'tuesday':
        return DayOfWeekEnum.tuesday;
      case 'wednesday':
        return DayOfWeekEnum.wednesday;
      case 'thursday':
        return DayOfWeekEnum.thursday;
      case 'friday':
        return DayOfWeekEnum.friday;
      case 'saturday':
        return DayOfWeekEnum.saturday;
      case 'sunday':
        return DayOfWeekEnum.sunday;
      default:
        throw Exception('Unknown type: $value');
    }
  }

  static String toStringValue(DayOfWeekEnum value) {
    switch (value) {
      case DayOfWeekEnum.monday:
        return 'monday';
      case DayOfWeekEnum.tuesday:
        return 'tuesday';
      case DayOfWeekEnum.wednesday:
        return 'wednesday';
      case DayOfWeekEnum.thursday:
        return 'thursday';
      case DayOfWeekEnum.friday:
        return 'friday';
      case DayOfWeekEnum.saturday:
        return 'saturday';
      case DayOfWeekEnum.sunday:
        return 'sunday';
      default:
        throw Exception('Unknown type: $value');
    }
  }

  static String toDayAbbreviation(DayOfWeekEnum value) {
    switch (value) {
      case DayOfWeekEnum.monday:
        return '月';
      case DayOfWeekEnum.tuesday:
        return '火';
      case DayOfWeekEnum.wednesday:
        return '水';
      case DayOfWeekEnum.thursday:
        return '木';
      case DayOfWeekEnum.friday:
        return '金';
      case DayOfWeekEnum.saturday:
        return '土';
      case DayOfWeekEnum.sunday:
        return '日';
      default:
        throw Exception('Unknown type: $value');
    }
  }
}
