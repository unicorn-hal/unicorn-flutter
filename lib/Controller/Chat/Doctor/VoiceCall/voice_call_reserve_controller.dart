import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
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

  late DateTime? reserveDate;
  int? selectedTimeSlotIndex;

  DateTime _calendarDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<String> get _timeSlots => generateHalfHourSlots(doctor.callSupportHours);

  @override
  void initialize() async {
    // 初期値は現在時刻
    reserveDate = DateTime.now();
  }

  /// 通話予約を行う
  Future<void> reserveCall() async {
    ProtectorNotifier().enableProtector();
    // 予約日時を結合

    CallRequest body = CallRequest(
      doctorId: doctor.doctorId,
      userId: AccountData().account!.uid,
      callStartTime: reserveDate!,
      // 一旦固定で30分間に設定
      callEndTime: reserveDate!.add(
        const Duration(minutes: 30),
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
        '通話予約が完了しました！ \n\n■予約内容\n${DateFormat('yyyy年MM月dd日').format(reserveDate!)}\n\n■時間\n${DateFormat('HH:mm').format(reserveDate!)}〜${DateFormat('HH:mm').format(reserveDate!.add(const Duration(minutes: 30)))}\n\n■医師名\n${doctor.lastName + doctor.firstName}\n\n■その他\n通話・予約に関してのお問い合わせはアプリ内「プロフィール > お問い合わせ」からお申し上げください。';

    ChatDoctorTextChatRoute(
            doctorId: doctor.doctorId,
            doctorName: doctor.lastName + doctor.firstName,
            reserveMessage: reserveMessage)
        .push(context!);
    return;
  }

  // 選択された日時をセット
  void setReserveDate(DateTime? date, int? index) {
    reserveDate = date;
    selectedTimeSlotIndex = index;
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

  /// 通話対応可能時間の文字列を30分ごとのリストに変換する関数
  List<String> generateHalfHourSlots(String timeRange) {
    // 例: '10:00-17:00'

    // 文字列を '-' で分割して開始時間と終了時間を取得
    List<String> parts = timeRange.split('-');
    if (parts.length != 2) {
      throw FormatException("時間帯のフォーマットが正しくありません。");
    }

    // 開始時間と終了時間をパース
    DateTime startTime = _parseTime(parts[0]);
    DateTime endTime = _parseTime(parts[1]);

    // 開始時間が終了時間より後の場合はエラー
    if (startTime.isAfter(endTime)) {
      throw FormatException("開始時間が終了時間より後です。");
    }

    List<String> slots = [];
    DateTime current = startTime;

    while (current.isBefore(endTime)) {
      DateTime slotEnd = current.add(Duration(minutes: 30));

      // スロットの終了時間が全体の終了時間を超えないように調整
      if (slotEnd.isAfter(endTime)) {
        slotEnd = endTime;
      }

      // スロットのフォーマットを 'HH:mm〜HH:mm' に変換
      String slot =
          '${_formatTime(current)}〜${_formatTime(slotEnd.subtract(Duration(minutes: 1)))}';
      slots.add(slot);

      // 次のスロットへ進む
      current = current.add(Duration(minutes: 30));
    }

    return slots;
  }

  /// 'HH:mm' 形式の時間文字列をDateTimeオブジェクトに変換
  DateTime _parseTime(String timeStr) {
    List<String> parts = timeStr.split(':');
    if (parts.length != 2) {
      throw FormatException("時間のフォーマットが正しくありません。");
    }

    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // 今日の日付に時間を設定
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  /// DateTimeオブジェクトを 'HH:mm' 形式の文字列に変換
  String _formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  /// 取得した通話対応可能時間のリストと比較してboolを返す
  bool isAvailableTimeSlot(
    List<Call>? reservedCalls,
    String targetTimeSlot,
  ) {
    if (reservedCalls == null) {
      return true;
    }

    String targetStartTime = (targetTimeSlot.split('〜').first);
    for (Call call in reservedCalls) {
      final String reservedString =
          call.callStartTime.toLocal().toString().substring(11, 16);
      if (reservedString == targetStartTime) {
        return false;
      }
    }
    return true;
  }

  List<String> get timeSlots => _timeSlots;
}
