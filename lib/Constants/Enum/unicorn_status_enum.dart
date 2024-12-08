enum UnicornStatusEnum {
  request,
  userWaiting,
  dispatch,
  moving,
  arrival,
  complete,
  failure,
}

class UnicornStatusType {
  static UnicornStatusEnum fromString(String value) {
    switch (value) {
      case 'request':
        return UnicornStatusEnum.request;
      case 'user_waiting':
        return UnicornStatusEnum.userWaiting;
      case 'dispatch':
        return UnicornStatusEnum.dispatch;
      case 'moving':
        return UnicornStatusEnum.moving;
      case 'arrival':
        return UnicornStatusEnum.arrival;
      case 'complete':
        return UnicornStatusEnum.complete;
      case 'failure':
        return UnicornStatusEnum.failure;
      default:
        return UnicornStatusEnum.request;
    }
  }

  static String toStringValue(UnicornStatusEnum value) {
    switch (value) {
      case UnicornStatusEnum.request:
        return 'request';
      case UnicornStatusEnum.userWaiting:
        return 'user_waiting';
      case UnicornStatusEnum.dispatch:
        return 'dispatch';
      case UnicornStatusEnum.moving:
        return 'moving';
      case UnicornStatusEnum.arrival:
        return 'arrival';
      case UnicornStatusEnum.complete:
        return 'complete';
      case UnicornStatusEnum.failure:
        return 'failure';
      default:
        return 'request';
    }
  }

  static String toExpressiveString(UnicornStatusEnum value) {
    switch (value) {
      case UnicornStatusEnum.request:
        return 'Unicorn要請中';
      case UnicornStatusEnum.userWaiting:
        return 'ユーザー待機中';
      case UnicornStatusEnum.dispatch:
        return 'Unicorn出発';
      case UnicornStatusEnum.moving:
        return 'Unicorn移動中';
      case UnicornStatusEnum.arrival:
        return 'Unicorn到着';
      case UnicornStatusEnum.complete:
        return '対応完了';
      case UnicornStatusEnum.failure:
        return '失敗';
      default:
        return 'Unicorn要請中';
    }
  }
}
