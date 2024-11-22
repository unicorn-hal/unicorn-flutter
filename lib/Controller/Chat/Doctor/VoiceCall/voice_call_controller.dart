// voice_call_controller.dart

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/Agora/agora_certificate.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unicorn_flutter/Model/Entity/Agora/agora_certificate_request.dart';
import 'package:unicorn_flutter/Service/Package/Agora/Api/agora_certificate_api.dart';

class VoiceCallController extends ControllerCore {
  final Doctor _doctor;
  late int remoteUid;
  late RtcEngine _engine;
  bool isMuted = false;
  bool isSwapped = false;
  String? _token;

  final ValueNotifier<bool> _isCallConnected = ValueNotifier(false);

  VoiceCallController({required Doctor doctor}) : _doctor = doctor;

  Doctor get doctor => _doctor;
  RtcEngine get engine => _engine;
  ValueNotifier<bool> get isCallConnected => _isCallConnected;

  final AgoraCertificateApi _agoraApi = AgoraCertificateApi();

  @override
  Future<void> initialize() async {
    await _initAgoraEngine();
    await _fetchToken();
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

  Future<void> _fetchToken() async {
    AgoraCertificateRequest request = AgoraCertificateRequest(
      channelName: 'test',
      uid: '0',
    );
    AgoraCertificate? certificate = await _agoraApi.fetchToken(body: request);
    if (certificate != null) {
      _token = certificate.token;
    } else {
      // トークン取得に失敗した場合の処理
      _token = '';
    }
  }

  Future<void> _joinChannel() async {
    await _engine.startPreview();
    await _engine.joinChannel(
      token: _token!,
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

  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    _isCallConnected.dispose();
  }
}
