import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isAvailable = false;

  /// 音声認識の初期化
  Future<bool> initialize() async {
    _isAvailable = await _speech.initialize();
    return _isAvailable;
  }

  /// 音声認識の開始
  void startListening(Function(String) onResult) {
    if (_isAvailable) {
      _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
        // 日本語で音声認識を行う
        localeId: 'ja_JP',
      );
    }
  }

  /// 音声認識の停止
  void stopListening() {
    if (_isAvailable) {
      _speech.stop();
    }
  }

  /// 現在の音声認識状態を取得
  bool get isAvailable => _isAvailable;

  /// 音声認識が現在リスニング中か
  bool get isListening => _speech.isListening;
}
