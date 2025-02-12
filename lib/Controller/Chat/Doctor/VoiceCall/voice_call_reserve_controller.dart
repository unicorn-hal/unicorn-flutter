import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';
import 'package:unicorn_flutter/View/bottom_navigation_bar_view.dart';
import '../../../../Model/Data/User/user_data.dart';
import '../../../../Model/Entity/Call/call.dart';
import '../../../../Model/Entity/Call/call_request.dart';
import '../../../../Model/Entity/Doctor/doctor.dart';
import '../../../../Service/Api/Call/call_api.dart';
import '../../../Core/controller_core.dart';

class VoiceCallReserveController extends ControllerCore {
  CallApi get _callApi => CallApi();
  DoctorApi get _doctorApi => DoctorApi();

  VoiceCallReserveController(this.context, this._doctor);

  BuildContext? context;
  final Doctor _doctor;

  DateTime? _reserveDate;
  int? selectedTimeSlotIndex;

  DateTime _calendarDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<String> get _timeSlots =>
      _generateHalfHourSlots(_doctor.callSupportHours);

  @override
  void initialize() async {}

  Doctor get doctor => _doctor;

  /// 通話予約を行う
  Future<void> reserveCall() async {
    if (_reserveDate == null || selectedTimeSlotIndex == null) {
      Fluttertoast.showToast(msg: Strings.VOICE_CALL_SET_ERROR_TEXT);
      return;
    }
    ProtectorNotifier().enableProtector();
    // 予約日時を結合
    CallRequest body = CallRequest(
      doctorId: _doctor.doctorId,
      userId: UserData().user!.userId,
      callStartTime: _reserveDate!,
      // 一旦固定で30分間に設定
      callEndTime: _reserveDate!.add(
        const Duration(minutes: 30),
      ),
    );

    // 通話予約APIを呼び出す
    final int response = await _callApi.postCall(body: body);

    ProtectorNotifier().disableProtector();

    if (response != 200) {
      Fluttertoast.showToast(msg: Strings.VOICE_CALL_RESERVE_ERROR_TEXT);
      return;
    }

    // 通話予約に成功した場合
    final String reserveMessage =
        '通話予約が完了しました！ \n\n■予約内容\n${DateFormat('yyyy年MM月dd日').format(_reserveDate!)}\n\n■時間\n${DateFormat('HH:mm').format(_reserveDate!)}〜${DateFormat('HH:mm').format(_reserveDate!.add(const Duration(minutes: 29)))}\n\n■医師名\n${_doctor.lastName + _doctor.firstName}\n\n■その他\n通話・予約に関してのお問い合わせはアプリ内「プロフィール > お問い合わせ」からお申し上げください。';

    // 予約日時を初期化
    selectedTimeSlotIndex = null;
    _reserveDate = null;

    ChatDoctorTextChatRoute($extra: _doctor, reserveMessage: reserveMessage)
        .push(context!);
    return;
  }

  // 選択された日時をセット
  void setReserveDate({int? index}) {
    if (index == null) {
      _reserveDate = null;
      selectedTimeSlotIndex = null;
      return;
    }

    _reserveDate = DateTime(
      calendarDate.year,
      calendarDate.month,
      calendarDate.day,
      int.parse(timeSlots[index].split('〜')[0].split(':')[0]),
      int.parse(timeSlots[index].split('〜')[0].split(':')[1]),
    );
    selectedTimeSlotIndex = index;
  }

  // カレンダーの日付変更
  void changeCalendarDate(DateTime date) {
    _calendarDate = date;
  }

  /// 医師の通話予約一覧を取得
  Future<Map<DateTime, List<Call>>?> getDoctorReservation() async {
    final List<Call>? callList =
        await _doctorApi.getDoctorCallList(doctorId: _doctor.doctorId);

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
  List<String> _generateHalfHourSlots(String timeRange) {
    // 例: '10:00-17:00'

    // 文字列を '-' で分割して開始時間と終了時間を取得
    List<String> parts = timeRange.split('-');
    if (parts.length != 2) {
      throw const FormatException("時間帯のフォーマットが正しくありません。");
    }

    // 開始時間と終了時間をパース
    DateTime startTime = _parseTime(parts[0]);
    DateTime endTime = _parseTime(parts[1]);

    // 開始時間が終了時間より後の場合はエラー
    if (startTime.isAfter(endTime)) {
      throw const FormatException("開始時間が終了時間より後です。");
    }

    List<String> slots = [];
    DateTime current = startTime;

    while (current.isBefore(endTime)) {
      DateTime slotEnd = current.add(const Duration(minutes: 30));

      // スロットの終了時間が全体の終了時間を超えないように調整
      if (slotEnd.isAfter(endTime)) {
        slotEnd = endTime;
      }

      // スロットのフォーマットを 'HH:mm〜HH:mm' に変換
      String slot =
          '${_formatTime(current)}〜${_formatTime(slotEnd.subtract(const Duration(minutes: 1)))}';
      slots.add(slot);

      // 次のスロットへ進む
      current = current.add(const Duration(minutes: 30));
    }

    return slots;
  }

  /// 'HH:mm' 形式の時間文字列をDateTimeオブジェクトに変換
  DateTime _parseTime(String timeStr) {
    List<String> parts = timeStr.split(':');
    if (parts.length != 2) {
      throw const FormatException("時間のフォーマットが正しくありません。");
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
    int index,
  ) {
    if (reservedCalls == null) {
      return _availableTimeCheck(timeSlots[index]);
    }

    String targetStartTime = (timeSlots[index].split('〜').first);
    for (Call call in reservedCalls) {
      final String reservedString =
          call.callStartTime.toLocal().toString().substring(11, 16);
      if (reservedString == targetStartTime) {
        return false;
      }
    }

    return _availableTimeCheck(timeSlots[index]);
  }

  /// 予約日時が過去であるかのチェック
  bool _availableTimeCheck(String timeSlot) {
    // 確認する値が現在時刻より後であればtrueを返す
    if (!_calendarDate.isBefore(DateTime.now())) {
      return true;
    }

    final DateTime now = DateTime.now();
    final DateTime slotStart = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(
        timeSlot.split('〜').first.split(':')[0],
      ),
      int.parse(
        timeSlot.split('〜').first.split(':')[1],
      ),
    );

    if (now.isAfter(slotStart)) {
      return false;
    }
    return true;
  }

  List<String> get timeSlots => _timeSlots;
}
