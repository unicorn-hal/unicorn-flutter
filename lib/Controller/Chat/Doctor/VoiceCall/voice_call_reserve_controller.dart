import 'package:unicorn_flutter/Service/Log/log_service.dart';

import '../../../../Model/Data/Account/account_data.dart';
import '../../../../Model/Entity/Call/call_request.dart';
import '../../../../Service/Api/Call/call_api.dart';
import '../../../Core/controller_core.dart';

class VoiceCallReserveController extends ControllerCore {
  CallApi get _callApi => CallApi();

  VoiceCallReserveController(this.doctorId);

  final String doctorId;
  late DateTime _reserveDate;
  late DateTime _reserveTime;

  @override
  void initialize() async {
    // 初期値は現在時刻
    _reserveDate = DateTime.now();
    _reserveTime = DateTime.now();
  }

  // 通話予約を行う
  Future<void> reserveCall() async {
    // 予約日時を結合
    final reserveDateTime = DateTime(
      _reserveDate.year,
      _reserveDate.month,
      _reserveDate.day,
      _reserveTime.hour,
      _reserveTime.minute,
    );

    CallRequest body = CallRequest(
      doctorId: doctorId,
      userId: AccountData().account!.uid,
      callStartTime: reserveDateTime,
      // 一旦固定で30分間に設定
      callEndTime: reserveDateTime.add(
        const Duration(minutes: 30),
      ),
    );
    print(body.toJson().toString());

    // 通話予約APIを呼び出す
    final int response = await _callApi.postCall(body: body);

    if (response != 200) {
      // todo: エラー処理
    }
    Log.echo('$response');
  }

  // 日付の変更
  void changeDate(DateTime date) {
    _reserveDate = date;
  }

  // 時間の変更
  void changeTime(DateTime time) {
    _reserveTime = time;
  }
}
