import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';

import '../../../../Model/Data/Account/account_data.dart';
import '../../../../Model/Entity/Call/call.dart';
import '../../../../Model/Entity/Call/call_request.dart';
import '../../../../Model/Entity/Doctor/doctor.dart';
import '../../../../Service/Api/Call/call_api.dart';
import '../../../Core/controller_core.dart';

class VoiceCallReserveController extends ControllerCore {
  CallApi get _callApi => CallApi();
  DoctorApi get _doctorApi => DoctorApi();

  VoiceCallReserveController(this.context, this.doctor);

  BuildContext? context;
  final Doctor doctor;

  late DateTime _reserveDate;
  late DateTime _reserveTime;
  DateTime _calendarDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  void initialize() async {
    // 初期値は現在時刻
    _reserveDate = DateTime.now();
    _reserveTime = DateTime.now();
  }

  /// 通話予約を行う
  Future<void> reserveCall() async {
    ProtectorNotifier().enableProtector();
    // 予約日時を結合
    final DateTime reserveDateTime = DateTime(
      _reserveDate.year,
      _reserveDate.month,
      _reserveDate.day,
      _reserveTime.hour,
      _reserveTime.minute,
    );

    CallRequest body = CallRequest(
      doctorId: doctor.doctorId,
      userId: AccountData().account!.uid,
      callStartTime: reserveDateTime,
      // 一旦固定で30分間に設定
      callEndTime: reserveDateTime.add(
        const Duration(minutes: 10),
      ),
    );

    // 通話予約APIを呼び出す
    final int response = await _callApi.postCall(body: body);

    ProtectorNotifier().disableProtector();

    if (response != 200) {
      // todo: エラー処理
      Fluttertoast.showToast(msg: '通話予約に失敗しました');
      return;
    }

    // 通話予約に成功した場合
    final String reserveMessage =
        '通話予約が完了しました！ \n\n■予約内容\n${DateFormat('yyyy年MM月dd日').format(reserveDateTime)}\n\n■時間\n${DateFormat('HH:mm').format(reserveDateTime)}〜${DateFormat('HH:mm').format(reserveDateTime.add(const Duration(minutes: 10)))}\n\n■医師名\n${doctor.lastName + doctor.firstName}\n\n■その他\n通話・予約に関してのお問い合わせはアプリ内「プロフィール > お問い合わせ」からお申し上げください。';

    ChatDoctorTextChatRoute(
            doctorId: doctor.doctorId,
            doctorName: doctor.lastName + doctor.firstName,
            reserveMessage: reserveMessage)
        .push(context!);
    return;
  }

  // 日付の変更
  void changeDate(DateTime date) {
    _reserveDate = date;
  }

  // 時間の変更
  void changeTime(DateTime time) {
    _reserveTime = time;
  }

  // カレンダーの日付変更
  void changeCalendarDate(DateTime date) {
    _calendarDate = date;
  }

  Future<Map<DateTime, List<Call>>?> getDoctorReservation() async {
    final List<Call>? callList =
        await _doctorApi.getDoctorCallList(doctorId: doctor.doctorId);

    if (callList == null) {
      Fluttertoast.showToast(msg: Strings.ERROR_RESPONSE_TEXT);
      return null;
    }

    final Map<DateTime, List<Call>> events = {};

    // 予約情報をカレンダーに表示する形に変換
    for (final Call call in callList) {
      // 予約日時の日付部分を取得
      final DateTime callDate = DateTime(
        call.callStartTime.year,
        call.callStartTime.month,
        call.callStartTime.day,
      );

      // 予約日時の日付がカレンダーの日付と一致する場合
      if (events.containsKey(callDate)) {
        events[callDate]!.add(call);
      } else {
        events[callDate] = [call];
      }
    }

    return events;
  }

  /// DateTimeを日付のみに変換(キーとして使用するため)
  DateTime normalizeDate(DateTime date) {
    final localDate = date.toLocal();
    return DateTime(localDate.year, localDate.month, localDate.day);
  }

  DateTime get calendarDate => _calendarDate;
}
