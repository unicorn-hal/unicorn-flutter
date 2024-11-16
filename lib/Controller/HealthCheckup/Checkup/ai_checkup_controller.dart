import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:unicorn_flutter/Service/Package/SpeechToText/speech_to_text_service.dart';
import '../../Core/controller_core.dart';

class AiCheckupController extends ControllerCore {
  final SpeechToTextService _speechToTextService = SpeechToTextService();

  // コンストラクタ
  AiCheckupController();

  // 変数の定義
  late ValueNotifier<String> _aiText;
  late bool _isListening;

  // オーディオを初期化
  final _audioPlayer = AudioPlayer();

  @override
  void initialize() async {
    _aiText = ValueNotifier<String>('なんでも聞いてください');
    _isListening = false;
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
  }

  // 音声認識中かを取得
  bool get isListening => _isListening;

  // 音声認識結果を取得
  ValueNotifier<String> get aiText => _aiText;
}
