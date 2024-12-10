enum EmergencyStatusEnum {
  request,
  userWaiting,
  dispatch,
  moving,
  arrival,
  complete,
  failure,
}

class EmergencyStatusType {
  static EmergencyStatusEnum fromString(String value) {
    switch (value) {
      case 'request':
        return EmergencyStatusEnum.request;
      case 'user_waiting':
        return EmergencyStatusEnum.userWaiting;
      case 'dispatch':
        return EmergencyStatusEnum.dispatch;
      case 'moving':
        return EmergencyStatusEnum.moving;
      case 'arrival':
        return EmergencyStatusEnum.arrival;
      case 'complete':
        return EmergencyStatusEnum.complete;
      case 'failure':
        return EmergencyStatusEnum.failure;
      default:
        return EmergencyStatusEnum.request;
    }
  }

  static String toStringValue(EmergencyStatusEnum value) {
    switch (value) {
      case EmergencyStatusEnum.request:
        return 'request';
      case EmergencyStatusEnum.userWaiting:
        return 'user_waiting';
      case EmergencyStatusEnum.dispatch:
        return 'dispatch';
      case EmergencyStatusEnum.moving:
        return 'moving';
      case EmergencyStatusEnum.arrival:
        return 'arrival';
      case EmergencyStatusEnum.complete:
        return 'complete';
      case EmergencyStatusEnum.failure:
        return 'failure';
      default:
        return 'request';
    }
  }

  static String toLogString(EmergencyStatusEnum value) {
    switch (value) {
      case EmergencyStatusEnum.request:
        return 'Unicornを要請しました';
      case EmergencyStatusEnum.userWaiting:
        return 'ユーザー待機中';
      case EmergencyStatusEnum.dispatch:
        return 'Unicornが出発しました';
      case EmergencyStatusEnum.moving:
        return 'Unicornが移動中です';
      case EmergencyStatusEnum.arrival:
        return 'Unicornが到着しました';
      case EmergencyStatusEnum.complete:
        return '対応完了';
      case EmergencyStatusEnum.failure:
        return '失敗';
      default:
        return 'Unicornを要請しました';
    }
  }
}
