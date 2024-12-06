import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_reservation.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';

class CallReservationController extends ControllerCore {
  /// Serviceのインスタンス化
  UserApi get _userApi => UserApi();

  /// コンストラクタ
  CallReservationController();

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装
  Future<List<CallReservation>?> getCallReservation() async {
    List<CallReservation>? res =
        await _userApi.getUserCallReservation(userId: UserData().user!.userId);
    return res;
  }
}
