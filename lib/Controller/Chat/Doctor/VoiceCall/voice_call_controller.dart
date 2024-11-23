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

  final Call _call;
  Doctor? _doctor;

  late RtcEngine _engine;
  bool isMuted = false;
  bool isSwapped = false;

  int? _uid;
  String? _token;

  final ValueNotifier<bool> _isUserJoined = ValueNotifier(false);

  VoiceCallController({required Call call, required this.context})
      : _call = call;
  BuildContext context;

  Call get call => _call;
  Doctor? get doctor => _doctor;

  RtcEngine get engine => _engine;

  int? get uid => _uid;

  ValueNotifier<bool> get isUserJoined => _isUserJoined;

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
          if (state == RemoteVideoState.remoteVideoStateStopped) {
            endCall();
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

  Future<void> _fetchDoctor() async {
    Doctor? res = await _doctorApi.getDoctor(doctorId: _call.doctorId);
    if (res != null) {
      _doctor = res;
    }
  }

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
    const HomeRoute().go(context);
  }

  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    _isUserJoined.dispose();
  }
}
