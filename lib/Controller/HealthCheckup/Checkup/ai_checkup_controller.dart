import 'package:unicorn_flutter/Service/Package/SpeechToText/speech_to_text_service.dart';

import '../../Core/controller_core.dart';

class AiCheckupController extends ControllerCore {
  SpeechToTextService get _speechToTextService => SpeechToTextService();

  // コンストラクタ
  AiCheckupController();

  // 変数の定義
  late String _aiText;

  @override
  void initialize() {
    _aiText = 'どんなことでも聞いてください';
    _speechToTextService.initialize();
  }

  // 音声認識を開始
  void startListening() {
    _speechToTextService.startListening((String result) => _aiText = result);
  }

  // 音声認識を停止
  void stopListening() {
    _speechToTextService.stopListening();
  }

  // 音声認識中かを取得
  bool get isListening => _speechToTextService.isListening;

  // 音声認識結果を取得
  String get aiText => _aiText;
}
