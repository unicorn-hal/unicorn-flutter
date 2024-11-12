import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/VoiceCall/voice_call_controller.dart';

class VoiceCallView extends StatefulWidget {
  final String calleeUid;

  const VoiceCallView({super.key, required this.calleeUid});

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  late VoiceCallController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VoiceCallController(calleeUid: widget.calleeUid);
    _controller.isCallConnected.addListener(() {
      setState(() {}); // 通話状態が変化したら画面を更新
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onToggleMute() {
    setState(() {
      _controller.toggleMute();
    });
  }

  void _onToggleCamera() {
    setState(() {
      _controller.toggleCamera();
    });
  }

  void _onEndCall() {
    _controller.endCall();
    Navigator.of(context).pop(); // 前の画面に戻る
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isCallConnected.value) {
      // 通話待機画面
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.calleeUid} さんとの通話中...'),
        ),
        body: const Center(
          child: Text('通話接続を待っています...'),
        ),
      );
    } else {
      // ビデオ通話画面
      return Scaffold(
        appBar: AppBar(
          title: Text('ビデオ通話 - ${_controller.userId}'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: RTCVideoView(_controller.localRenderer,
                              mirror: true),
                        ),
                        Expanded(
                          child: RTCVideoView(_controller.remoteRenderer),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(_controller.isMuted ? Icons.mic_off : Icons.mic),
                  onPressed: _onToggleMute,
                ),
                IconButton(
                  icon: Icon(_controller.isCameraOff
                      ? Icons.videocam_off
                      : Icons.videocam),
                  onPressed: _onToggleCamera,
                ),
                IconButton(
                  icon: const Icon(Icons.call_end),
                  onPressed: _onEndCall,
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
