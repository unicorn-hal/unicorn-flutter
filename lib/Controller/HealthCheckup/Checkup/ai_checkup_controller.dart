import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn_flutter/Constants/Enum/chatgpt_role.dart';
import 'package:unicorn_flutter/Constants/Enum/health_checkup_disease_enum.dart';
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_message.dart';
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_response.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/ChatGPT/chatgpt_service.dart';
import 'package:unicorn_flutter/Service/Package/PermissionHandler/permission_handler_service.dart';
import 'package:unicorn_flutter/Service/Package/SpeechToText/speech_to_text_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import '../../../View/bottom_navigation_bar_view.dart';
import '../../Core/controller_core.dart';

class AiCheckupController extends ControllerCore {
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  ChatGPTService get _chatGPTService => ChatGPTService();
  PermissionHandlerService get _permissionHandlerService =>
      PermissionHandlerService();

  // コンストラクタ
  AiCheckupController(this.context);

  BuildContext context;

  // 変数の定義
  late ValueNotifier<String> _aiText;
  final String _aiTextDefault = 'なんでも聞いてください';
  final int _baseHealthPoint = 3;
  bool _isListening = false;
  bool _isDone = false;
  late bool _isAvailable;

  // オーディオを初期化
  final _audioPlayer = AudioPlayer();

  @override
  void initialize() async {
    _aiText = ValueNotifier<String>(_aiTextDefault);
    // 音声認識の初期化
    _isAvailable = await _speechToTextService.initialize();
    if (!_isAvailable) {
      await _showErrorDialog();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  /// 音声認識を開始
  Future<void> startListening() async {
    if (_isListening) return;
    HapticFeedback.heavyImpact();
    // 音声開始効果音を再生
    // todo: もっと良いものがあれば変更
    _audioPlayer.play(
      AssetSource('sounds/start_voice_recording.mp3'),
      volume: 0.5,
    );

    _isListening = true;
    _speechToTextService.startListening(
      (String result) {
        _aiText.value = result;
      },
    );
  }

  /// 音声認識を停止
  void stopListening() {
    // 効果音停止
    _audioPlayer.stop();
    _isListening = false;
    _speechToTextService.stopListening();
    _isDone = true;
  }

  /// 検診結果へ必要な情報をまとめて画面遷移する
  Future<void> navigateToCheckupResult() async {
    ProtectorNotifier().enableProtector();
    String? result = await getDiseaseEnumString();
    if (result == null) {
      ProtectorNotifier().disableProtector();
      Fluttertoast.showToast(msg: '適切な回答をしてください');
      return;
    }

    ProtectorNotifier().disableProtector();

    HealthCheckupDiseaseEnum diseaseType =
        HealthCheckupDiseaseType.fromString(result);

    int healthPoint = _baseHealthPoint;

    if (diseaseType == HealthCheckupDiseaseEnum.goodHealth) {
      healthPoint = -2;
    } else {
      healthPoint = 3;
    }

    ProgressRoute(
      from: Routes.healthCheckupAi,
      diseaseType: diseaseType,
      healthPoint: healthPoint,
      // ignore: use_build_context_synchronously
    ).go(context);
  }

  /// 認識した音声をChatGPTに送信してEnumを返す
  Future<String?> getDiseaseEnumString() async {
    final ChatGPTMessage message = ChatGPTMessage(
      role: ChatGPTRole.user,
      content: '''
      **重要**
      下記に健康診断の音声認識結果を入力するので、症状を推測してgoodHealth,highFever,badFeel,painfulChest,painfulStomach,painfulHead,のいずれか1つを答えてください。
      回答に解説は含めないでください。6つの選択肢のうち、最も適切なものを選択してください。

      # goodHealthは健康という意味です。特に症状がない場合に選択してください。
      # highFeverは高熱という意味です。体温が高い場合や、熱が出ている場合に選択してください。
      # badFeelは体調が悪いという意味です。体調が悪い場合に選択してください。
      # painfulChestは胸が痛いという意味です。胸に関する内容がある場合に選択してください。
      # painfulStomachはお腹が痛いという意味です。お腹に関する内容がある場合に選択してください。
      # painfulHeadは頭が痛いという意味です。頭に関する内容がある場合に選択してください。

      **ここからは音声認識結果です**
      ${_aiText.value}
      ''',
    );

    final ChatGPTResponse? response =
        await _chatGPTService.postChatGPTMessage([message]);

    if (response == null) {
      return null;
    }

    // 返答が規定のものでなければnullを返す
    if (response.message.content != 'goodHealth' &&
        response.message.content != 'highFever' &&
        response.message.content != 'badFeel' &&
        response.message.content != 'painfulChest' &&
        response.message.content != 'painfulStomach' &&
        response.message.content != 'painfulHead') {
      return null;
    }

    return response.message.content;
  }

  /// 音声認識の終了状態を初期値に戻す
  void resetRecording() {
    _aiText.value = _aiTextDefault;
    _isDone = false;
  }

  /// 音声認識結果のバリデート
  bool textValidate() {
    if (_aiText.value.length < 3) {
      Fluttertoast.showToast(msg: '最低3文字以上は音声入力をしてください');
      return false;
    } else if (_aiText.value == _aiTextDefault) {
      Fluttertoast.showToast(msg: '音声入力をしてください');
      return false;
    }
    return true;
  }

  ///　マイクの権限が許可されていない場合のエラーダイアログ
  Future<void> _showErrorDialog() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomDialog(
          title: 'エラー',
          bodyText: 'AI検診を利用するためには「マイク」の許可が必要です。',
          rightButtonOnTap: () async {
            await _permissionHandlerService.openAppSettings();
          },
          rightButtonText: '端末設定を開く',
          leftButtonText: '戻る',
        );
      },
    );
  }

  // 音声認識中かを取得
  bool get isListening => _isListening;

  // 音声認識結果を取得
  ValueNotifier<String> get aiText => _aiText;

  // 音声認識が終了したかを取得
  bool get isDone => _isDone;
}
