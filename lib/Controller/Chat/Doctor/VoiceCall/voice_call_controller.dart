import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Entity/Agora/agora_certificate.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:unicorn_flutter/Model/Entity/Agora/agora_certificate_request.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Api/Doctor/doctor_api.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/Agora/Api/agora_certificate_api.dart';
import 'package:unicorn_flutter/Service/Package/PermissionHandler/permission_handler_service.dart';

class VoiceCallController extends ControllerCore {
  PermissionHandlerService get _permissionHandlerService =>
      PermissionHandlerService();
  AgoraCertificateApi get _agoraApi => AgoraCertificateApi();
  DoctorApi get _doctorApi => DoctorApi();

  late RtcEngine _engine;

  final Call _call;
  Doctor? _doctor;

  Offset localPreviewPos = const Offset(20, 100);

  bool _isMuted = false;
  bool _isSwapped = false;
  bool _useFrontCamera = true;
  Timer? _timer;
  int _elapsedTimeSec = 0;

  int? _uid;
  String? _token;

  final ValueNotifier<bool> _isUserJoined = ValueNotifier(false);
  final ValueNotifier<bool> _isLocalCameraEnabled = ValueNotifier(true);
  final ValueNotifier<bool> _isRemoteCameraEnabled = ValueNotifier(true);
  final ValueNotifier<bool> _isRemoteMutated = ValueNotifier(false);
  final ValueNotifier<String> _elapsedTime = ValueNotifier('00:00');

  VoiceCallController({required Call call, required this.context})
      : _call = call;
  BuildContext context;

  @override
  Future<void> initialize() async {
    // todo: パーミッション処理は遷移前に行う
    await _permissionHandlerService.checkAndRequestPermission(
      Permission.microphone,
    );
    await _permissionHandlerService.checkAndRequestPermission(
      Permission.camera,
    );

    await _initAgoraEngine();
    await _fetchToken();
    await _fetchDoctor();
    await _joinChannel();
  }

  RtcEngine get engine => _engine;

  Call get call => _call;
  Doctor? get doctor => _doctor;

  bool get isMuted => _isMuted;
  bool get isSwapped => _isSwapped;
  bool get useFrontCamera => _useFrontCamera;

  int? get uid => _uid;

  ValueNotifier<bool> get isUserJoined => _isUserJoined;
  ValueNotifier<bool> get isLocalCameraEnabled => _isLocalCameraEnabled;
  ValueNotifier<bool> get isRemoteCameraEnabled => _isRemoteCameraEnabled;
  ValueNotifier<bool> get isRemoteMutated => _isRemoteMutated;
  ValueNotifier<String> get elapsedTime => _elapsedTime;

  /// Agoraエンジンの初期化
  Future<void> _initAgoraEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: dotenv.env['AGORA_APP_ID']!,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, msg) {
          Log.echo('Error: $err, $msg');
          // todo: エラー処理
        },
        onJoinChannelSuccess: (connection, elapsed) {
          Log.echo('Join channel success: ${connection.channelId}');
        },
        onUserJoined: (connection, uid, elapsed) {
          Log.echo('User joined: $uid');
          _startTimer();
          _uid = uid;
          _isUserJoined.value = true;
        },
        onUserOffline: (connection, uid, reason) {
          endCall();
        },
        onRemoteVideoStateChanged: (
          connection,
          remoteUid,
          state,
          reason,
          elapsed,
        ) {
          Log.echo('Remote video state changed: $state');
          if (state == RemoteVideoState.remoteVideoStateDecoding) {
            isRemoteCameraEnabled.value = true;
          }
          if (state == RemoteVideoState.remoteVideoStateStopped) {
            isRemoteCameraEnabled.value = false;
          }
        },
        onRemoteAudioStateChanged: (
          connection,
          remoteUid,
          state,
          reason,
          elapsed,
        ) {
          Log.echo('Remote audio state changed: $state');
          if (state == RemoteAudioState.remoteAudioStateDecoding) {
            isRemoteMutated.value = false;
          }
          if (state == RemoteAudioState.remoteAudioStateStopped) {
            isRemoteMutated.value = true;
          }
        },
        onRequestToken: (connection) {
          Log.echo(
              'Request token: ${connection.channelId} ${connection.localUid}');
        },
      ),
    );
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  /// トークン取得
  Future<void> _fetchToken() async {
    AgoraCertificateRequest request = AgoraCertificateRequest(
      channelName: _call.callReservationId,
    );
    AgoraCertificate? certificate = await _agoraApi.fetchToken(body: request);
    if (certificate != null) {
      _uid = certificate.uid;
      _token = certificate.token;
    } else {
      // トークン取得に失敗した場合の処理
      _uid = null;
      _token = '';
    }
  }

  /// 医師情報取得
  Future<void> _fetchDoctor() async {
    Doctor? res = await _doctorApi.getDoctor(doctorId: _call.doctorId);
    if (res != null) {
      _doctor = res;
    }
  }

  /// チャンネル参加
  Future<void> _joinChannel() async {
    Log.echo('Joining channel...: $_token');
    await _engine.joinChannel(
      token: _token!,
      channelId: _call.callReservationId,
      uid: _uid!,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedTimeSec++;
      int minutes = _elapsedTimeSec ~/ 60;
      int seconds = _elapsedTimeSec % 60;
      _elapsedTime.value = '${minutes.toString().padLeft(2, '0')}'
          ':${seconds.toString().padLeft(2, '0')}';
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _elapsedTimeSec = 0;
    _elapsedTime.value = '00:00';
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    _engine.muteLocalAudioStream(_isMuted);
  }

  void toggleCamera() {
    _isLocalCameraEnabled.value = !_isLocalCameraEnabled.value;
    _engine.enableLocalVideo(_isLocalCameraEnabled.value);
  }

  void switchCamera() {
    _useFrontCamera = !_useFrontCamera;
    _engine.switchCamera();
  }

  void toggleSwap() {
    _isSwapped = !_isSwapped;
  }

  void endCall() {
    _engine.leaveChannel();
    _engine.release();
    const HomeRoute().go(context);
  }

  void dispose() {
    _isUserJoined.dispose();
    _isLocalCameraEnabled.dispose();
    _isRemoteCameraEnabled.dispose();
    _isRemoteMutated.dispose();
    _elapsedTime.dispose();
    _stopTimer();
  }
}
