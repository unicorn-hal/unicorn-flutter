// voice_call_controller.dart

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceCallController extends ControllerCore {
  final Doctor _doctor;
  late int remoteUid;
  late RtcEngine _engine;
  bool isMuted = false;
  bool isSwapped = false;

  final ValueNotifier<bool> _isCallConnected = ValueNotifier(false);

  VoiceCallController({required Doctor doctor}) : _doctor = doctor;

  Doctor get doctor => _doctor;
  RtcEngine get engine => _engine;
  ValueNotifier<bool> get isCallConnected => _isCallConnected;

  @override
  Future<void> initialize() async {
    await _initAgoraEngine();
    await _joinChannel();
  }

  Future<void> _initAgoraEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: dotenv.env['AGORA_APP_ID']!,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          _isCallConnected.value = true;
        },
        onUserJoined: (connection, uid, elapsed) {
          remoteUid = uid;
        },
        onUserOffline: (connection, uid, reason) {
          endCall();
        },
      ),
    );
    await _engine.enableVideo();
  }

  Future<void> _joinChannel() async {
    await _engine.startPreview();
    await _engine.joinChannel(
      token: dotenv.env['AGORA_TOKEN']!,
      channelId: 'test',
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  void toggleMute() {
    isMuted = !isMuted;
    _engine.muteLocalAudioStream(isMuted);
  }

  void switchCamera() {
    _engine.switchCamera();
  }

  void toggleSwap() {
    isSwapped = !isSwapped;
  }

  void endCall() {
    _engine.leaveChannel();
    _engine.release();
    _isCallConnected.value = false;
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    _isCallConnected.dispose();
  }
}
