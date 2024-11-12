import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VoiceCallController extends ControllerCore {
  late RTCPeerConnection peerConnection;
  late MediaStream localStream;
  late WebSocketChannel channel;
  final remoteRenderer = RTCVideoRenderer();
  final localRenderer = RTCVideoRenderer();
  final peersController = StreamController<List<String>>.broadcast();
  List<String> peers = [];
  String? selectedPeer;
  String userId = UserData().user!.userId; // ユーザー固有のID
  bool isMuted = false;
  bool isCameraOff = false;

  VoiceCallController();

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
        'targetId': selectedPeer,
        'userId': userId,
      });
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
          peers = List<String>.from(data['peers']);
          peersController.add(peers);
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

  Future<void> createOffer(Function onError) async {
    if (selectedPeer == null) {
      onError();
      return;
    }

    RTCSessionDescription offer = await peerConnection.createOffer();
    await peerConnection.setLocalDescription(offer);

    _sendSignalingMessage({
      'type': 'offer',
      'sdp': offer.sdp,
      'targetId': selectedPeer,
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

    _createPeerConnection().then((pc) {
      peerConnection = pc;
      _startLocalStream();
    });

    selectedPeer = null;
  }

  void dispose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    peerConnection.close();
    channel.sink.close();
    peersController.close();
  }
}
