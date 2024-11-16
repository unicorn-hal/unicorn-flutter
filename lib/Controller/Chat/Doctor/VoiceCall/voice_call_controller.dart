import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

class VoiceCallController extends ControllerCore {
  final Doctor _doctor;
  late String calleeUid;
  late RTCPeerConnection peerConnection;
  late MediaStream localStream;
  late WebSocketChannel channel;
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final String _userId = UserData().user!.userId; // ユーザー固有のID

  bool isMuted = false;
  bool isCameraOff = false;
  bool isFrontCamera = true;
  bool isSwapped = false;

  final ValueNotifier<bool> _isCallConnected = ValueNotifier(false);
  final ValueNotifier<String> _elapsedTime = ValueNotifier("00:00");
  final ValueNotifier<bool> _isMutedNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isCameraOffNotifier = ValueNotifier(false);

  Offset localVideoOffset = const Offset(20, 100);
  Timer? _timer;
  int _secondsElapsed = 0;

  VoiceCallController({required Doctor doctor}) : _doctor = doctor;

  // Getters and Setters
  Doctor get doctor => _doctor;

  RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  RTCVideoRenderer get localRenderer => _localRenderer;

  String get userId => _userId;

  ValueNotifier<bool> get isCallConnected => _isCallConnected;

  ValueNotifier<String> get elapsedTime => _elapsedTime;

  ValueNotifier<bool> get isMutedNotifier => _isMutedNotifier;

  ValueNotifier<bool> get isCameraOffNotifier => _isCameraOffNotifier;

  @override
  void initialize() {
    calleeUid = _doctor.doctorId;
    _initRenderers();
    _connectToSignalingServer();
    _createPeerConnection().then((pc) {
      peerConnection = pc;
      _startLocalStream();
    });

    _isCallConnected.addListener(() {
      if (_isCallConnected.value) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  Future<void> switchCamera() async {
    isFrontCamera = !isFrontCamera;
    localStream.getVideoTracks().forEach((track) async {
      await Helper.switchCamera(track);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
      final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
      _elapsedTime.value = "$minutes:$seconds";
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _secondsElapsed = 0;
    _elapsedTime.value = "00:00";
  }

  Future<void> _initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _startLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _localRenderer.srcObject = localStream;

    // ビデオトラックを有効化
    localStream.getVideoTracks().forEach((track) {
      track.enabled = true;
    });

    localStream.getTracks().forEach((track) {
      peerConnection.addTrack(track, localStream);
    });
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final Map<String, dynamic> configuration = {
      'iceServers': [
        {'urls': dotenv.env['STUN_SERVER_URL']},
      ],
    };

    final pc = await createPeerConnection(configuration);

    pc.onIceCandidate = (RTCIceCandidate candidate) {
      Log.echo('Sending ICE candidate to peer: ${candidate.toMap()}');
      _sendSignalingMessage({
        'type': 'candidate',
        'candidate': candidate.toMap(),
        'targetId': calleeUid,
        'userId': _userId,
      });
    };

    pc.onConnectionState = (RTCPeerConnectionState state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        // 通話が接続されたらフラグを更新
        _isCallConnected.value = true;
      }
    };

    pc.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        Log.echo('Received remote video track');
        _remoteRenderer.srcObject = event.streams.first;
      }
    };

    return pc;
  }

  void _connectToSignalingServer() {
    channel = WebSocketChannel.connect(
      Uri.parse(dotenv.env['SIGNALING_SERVER_URL']!),
    );

    channel.stream.listen((message) {
      String messageString;

      if (message is String) {
        messageString = message;
      } else if (message is Uint8List) {
        messageString = utf8.decode(message);
      } else {
        Log.echo('Unsupported message type received: ${message.runtimeType}');
        return;
      }

      var data = json.decode(messageString);

      switch (data['type']) {
        case 'offer':
          _handleOffer(data);
          break;
        case 'answer':
          _handleAnswer(data);
          break;
        case 'candidate':
          _handleCandidate(data);
          break;
        case 'peers':
          _handlePeersUpdate(data);
          break;
        default:
          break;
      }
    });

    _sendSignalingMessage({
      'type': 'register',
      'userId': _userId,
    });
  }

  void _sendSignalingMessage(Map<String, dynamic> message) {
    channel.sink.add(json.encode(message));
  }

  void _handleOffer(Map<String, dynamic> data) async {
    await peerConnection.setRemoteDescription(
      RTCSessionDescription(data['sdp'], 'offer'),
    );
    RTCSessionDescription answer = await peerConnection.createAnswer();
    await peerConnection.setLocalDescription(answer);

    _sendSignalingMessage({
      'type': 'answer',
      'sdp': answer.sdp,
      'targetId': data['userId'],
      'userId': _userId,
    });
  }

  void _handleAnswer(Map<String, dynamic> data) async {
    await peerConnection.setRemoteDescription(
      RTCSessionDescription(data['sdp'], 'answer'),
    );
  }

  void _handleCandidate(Map<String, dynamic> data) async {
    RTCIceCandidate candidate = RTCIceCandidate(
      data['candidate']['candidate'],
      data['candidate']['sdpMid'],
      int.parse(data['candidate']['sdpMLineIndex'].toString()),
    );
    await peerConnection.addCandidate(candidate);
  }

  void _handlePeersUpdate(Map<String, dynamic> data) {
    var peersList = List<String>.from(data['peers']);
    if (peersList.contains(calleeUid)) {
      // 通話相手がオンラインならピア接続を開始
      _createOffer();
    } else {
      // 通話相手がオフラインなら待機状態
    }
  }

  Future<void> _createOffer() async {
    RTCSessionDescription offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);

    _sendSignalingMessage({
      'type': 'offer',
      'sdp': offer.sdp,
      'targetId': calleeUid,
      'userId': _userId,
    });
  }

  void toggleSwap() {
    isSwapped = !isSwapped;
  }

  void toggleMute() {
    isMuted = !isMuted;
    localStream.getAudioTracks().forEach((track) {
      track.enabled = !isMuted;
    });
    _isMutedNotifier.value = isMuted;
  }

  void toggleCamera() {
    isCameraOff = !isCameraOff;
    localStream.getVideoTracks().forEach((track) {
      track.enabled = !isCameraOff;
    });
    _isCameraOffNotifier.value = isCameraOff;
  }

  void endCall() {
    peerConnection.close();
    localStream.getTracks().forEach((track) {
      track.stop();
    });
    _localRenderer.srcObject = null;
    _remoteRenderer.srcObject = null;
    _isCallConnected.value = false;
  }

  void dispose() {
    // カメラストリームを停止
    localStream.getTracks().forEach((track) {
      track.stop();
    });
    localStream.dispose();

    // Timerを停止
    _stopTimer();

    // ピアコネクションを閉じる
    peerConnection.close();

    _localRenderer.dispose();
    _remoteRenderer.dispose();
    peerConnection.close();
    channel.sink.close();
    _isCallConnected.dispose();
  }
}
