import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unicorn_flutter/Constants/Enum/chatgpt_role.dart';
import 'package:unicorn_flutter/Constants/Enum/progress_view_enum.dart';
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_message.dart';
import 'package:unicorn_flutter/Model/Entity/ChatGPT/chatgpt_response.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/ChatGPT/chatgpt_service.dart';
import 'package:unicorn_flutter/Service/Package/SpeechToText/speech_to_text_service.dart';
import '../../../View/bottom_navigation_bar_view.dart';
import '../../Core/controller_core.dart';

class AiCheckupController extends ControllerCore {
  final SpeechToTextService _speechToTextService = SpeechToTextService();
  ChatGPTService get _chatGPTService => ChatGPTService();

  // コンストラクタ
  AiCheckupController(this.context);

  BuildContext context;

  // 変数の定義
  late ValueNotifier<String> _aiText;
  final String _aiTextDefault = 'なんでも聞いてください';
  late bool _isListening;

  // オーディオを初期化
  final _audioPlayer = AudioPlayer();

  late bool finish;

  @override
  void initialize() async {
    _aiText = ValueNotifier<String>(_aiTextDefault);
    _isListening = false;
    finish = false;
    await _speechToTextService.initialize();
  }

  /// 音声認識を開始
  void startListening() {
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
    finish = true;
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

    /// 音声認識結果を元に画面遷移
    /// [$extra] はProgressViewEnumのbodyTemperatureを指定
    /// [from] は遷移元のRouteを指定
    /// [diseaseEnumString] は音声認識結果を指定
    CheckupProgressRoute(
      $extra: ProgressViewEnum.bodyTemperature,
      from: Routes.healthCheckupAi,
      diseaseEnumString: result,
    ).push(context);
  }

  /// 認識した音声をChatGPTに送信してEnumを返す
  Future<String?> getDiseaseEnumString() async {
    final ChatGPTMessage message = ChatGPTMessage(
      role: ChatGPTRole.user,
      content: '''
      **重要**
      下記に健康診断の音声認識結果を入力するので、症状を推測してhighFever,badFeel,painfulChest,painfulStomach,painfulHead,のいずれか1つを答えてください。
      回答に解説は含めないでください。5つの選択肢のうち、最も適切なものを選択してください。
      
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
    if (response.message.content != 'highFever' &&
        response.message.content != 'badFeel' &&
        response.message.content != 'painfulChest' &&
        response.message.content != 'painfulStomach' &&
        response.message.content != 'painfulHead') {
      return null;
    }

    return response.message.content;
  }

  /// 音声認識の終了状態を変更する
  void changeFinish() {
    _aiText.value = _aiTextDefault;
    finish = !finish;
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

  // 音声認識中かを取得
  bool get isListening => _isListening;

  // 音声認識結果を取得
  ValueNotifier<String> get aiText => _aiText;
}
