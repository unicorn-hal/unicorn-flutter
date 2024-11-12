import 'dart:async';
import 'dart:convert';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart';

class VoiceCallController extends ControllerCore {
  final String calleeUid;
  late RTCPeerConnection peerConnection;
  late MediaStream localStream;
  late WebSocketChannel channel;
  final remoteRenderer = RTCVideoRenderer();
  final localRenderer = RTCVideoRenderer();
  String userId = UserData().user!.userId; // ユーザー固有のID
  bool isMuted = false;
  bool isCameraOff = false;
  ValueNotifier<bool> isCallConnected = ValueNotifier(false);

  VoiceCallController({required this.calleeUid});

  @override
  void initialize() {
    _initRenderers();
    _connectToSignalingServer();
    _createPeerConnection().then((pc) {
      peerConnection = pc;
      _startLocalStream();
    });
  }

  Future<void> _initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<void> _startLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {
        'facingMode': 'user',
      }
    };

    localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    localRenderer.srcObject = localStream;

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
        {'urls': 'stun:10.205.112.53:3478'},
      ],
    };

    final pc = await createPeerConnection(configuration);

    pc.onIceCandidate = (RTCIceCandidate candidate) {
      debugPrint('Sending ICE candidate to peer: ${candidate.toMap()}');
      _sendSignalingMessage({
        'type': 'candidate',
        'candidate': candidate.toMap(),
        'targetId': calleeUid,
        'userId': userId,
      });
    };

    pc.onConnectionState = (RTCPeerConnectionState state) {
      if (state == RTCPeerConnectionState.RTCPeerConnectionStateConnected) {
        // 通話が接続されたらフラグを更新
        isCallConnected.value = true;
      }
    };

    pc.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        debugPrint('Received remote video track');
        remoteRenderer.srcObject = event.streams.first;
      }
    };

    return pc;
  }

  void _connectToSignalingServer() {
    channel = WebSocketChannel.connect(Uri.parse('ws://10.205.112.53:3000'));

    channel.stream.listen((message) {
      String messageString;

      if (message is String) {
        messageString = message;
      } else if (message is Uint8List) {
        messageString = utf8.decode(message);
      } else {
        debugPrint('Unsupported message type received: ${message.runtimeType}');
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
      'userId': userId,
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
      'userId': userId,
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
      'userId': userId,
    });
  }

  void toggleMute() {
    isMuted = !isMuted;
    localStream.getAudioTracks().forEach((track) {
      track.enabled = !isMuted;
    });
  }

  void toggleCamera() {
    isCameraOff = !isCameraOff;
    localStream.getVideoTracks().forEach((track) {
      track.enabled = !isCameraOff;
    });
  }

  void endCall() {
    peerConnection.close();
    localStream.getTracks().forEach((track) {
      track.stop();
    });
    localRenderer.srcObject = null;
    remoteRenderer.srcObject = null;
    isCallConnected.value = false;
  }

  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    peerConnection.close();
    channel.sink.close();
    isCallConnected.dispose();
  }
}
