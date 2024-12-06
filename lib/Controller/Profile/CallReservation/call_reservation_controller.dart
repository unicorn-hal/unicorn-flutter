import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call_reservation.dart';
import 'package:unicorn_flutter/Service/Api/Call/call_api.dart';
import 'package:unicorn_flutter/Service/Api/User/user_api.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

class CallReservationController extends ControllerCore {
  /// Serviceのインスタンス化
  UserApi get _userApi => UserApi();
  CallApi get _callApi => CallApi();

  /// コンストラクタ
  CallReservationController();

  /// initialize()
  @override
  void initialize() {}

  /// 各関数の実装
  /// 通話予約のリストを取得する関数
  Future<List<CallReservation>?> getCallReservation() async {
    List<CallReservation>? res =
        await _userApi.getUserCallReservation(userId: UserData().user!.userId);
    return res;
  }

  /// 通話予約を削除する関数
  Future<int> deleteCallReservation(String callReservationId) async {
    ProtectorNotifier().enableProtector();
    int res = await _callApi.deleteCall(callReservationId: callReservationId);
    if (res != 204) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
    }
    ProtectorNotifier().disableProtector();
    return res;
  }
}
