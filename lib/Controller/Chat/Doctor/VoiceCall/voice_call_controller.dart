import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
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

  final Call _call;
  // Doctor? _doctor;

  int remoteUid = 12345678;
  late RtcEngine _engine;
  bool isMuted = false;
  bool isSwapped = false;
  String? _token;

  final ValueNotifier<bool> _isChannelJoined = ValueNotifier(false);
  final ValueNotifier<bool> _isCallConnected = ValueNotifier(false);

  VoiceCallController({required Call call, required this.context})
      : _call = call;

  BuildContext context;

  Call get call => _call;
  // Doctor get doctor => _doctor;
  RtcEngine get engine => _engine;

  ValueNotifier<bool> get isChannelJoined => _isChannelJoined;
  ValueNotifier<bool> get isCallConnected => _isCallConnected;

  @override
  Future<void> initialize() async {
    await _permissionHandlerService.checkAndRequestPermission(
      Permission.microphone,
    );
    await _permissionHandlerService.checkAndRequestPermission(
      Permission.camera,
    );

    await _initAgoraEngine();
    await _fetchToken();
    // await _fetchDoctor();
    await _joinChannel();
  }

  Future<void> _initAgoraEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: dotenv.env['AGORA_APP_ID']!,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          Log.echo('Join channel success: $connection');
          _isChannelJoined.value = true;
        },
        onUserJoined: (connection, uid, elapsed) {
          Log.echo('User joined: $uid');
          remoteUid = uid;
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
            _isCallConnected.value = true;
          }
          if (state == RemoteVideoState.remoteVideoStateStopped) {
            endCall();
          }
        },
      ),
    );
    await _engine.enableVideo();
    await _engine.startPreview();
  }

  Future<void> _fetchToken() async {
    AgoraCertificateRequest request = AgoraCertificateRequest(
      channelName: 'test_channel',
      uid: '12345678',
    );
    AgoraCertificate? certificate = await _agoraApi.fetchToken(body: request);
    if (certificate != null) {
      _token = certificate.token;
    } else {
      // トークン取得に失敗した場合の処理
      _token = '';
    }
  }

  // Future<void> _fetchDoctor() async {
  //   Doctor? res = await _doctorApi.getDoctor(doctorId: _call.doctorId);
  //   if (res != null) {
  //     _doctor = res;
  //   }
  // }

  Future<void> _joinChannel() async {
    await _engine.startPreview();
    await _engine.joinChannel(
      token:
          '007eJxTYFj/KqZS28NiItsKrZlLwjcdYjwvFJy8WOMDcxeHW2nj+k4FBiPjRMPENFMzC8tUMxNzCxML8zTzpOREk5RUgzQTw1Tz5gkO6Q2BjAz1vg4MjFAI4vMwlKQWl8QnZyTm5aXmMDAAAK+tIGs=',
      channelId: 'test_channel',
      uid: 12345678,
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
    const HomeRoute().go(context);
  }

  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    _isChannelJoined.dispose();
    _isCallConnected.dispose();
  }
}
