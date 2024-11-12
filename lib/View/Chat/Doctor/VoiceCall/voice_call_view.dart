import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/VoiceCall/voice_call_controller.dart';

class VoiceCallView extends StatefulWidget {
  final String calleeUid;

  const VoiceCallView({Key? key, required this.calleeUid}) : super(key: key);

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  late VoiceCallController controller;

  @override
  void initState() {
    super.initState();
    controller = VoiceCallController(calleeUid: widget.calleeUid);
    controller.initialize();
    controller.isCallConnected.addListener(() {
      setState(() {}); // 通話状態が変化したら画面を更新
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onToggleMute() {
    setState(() {
      controller.toggleMute();
    });
  }

  void _onToggleCamera() {
    setState(() {
      controller.toggleCamera();
    });
  }

  void _onEndCall() {
    controller.endCall();
    Navigator.of(context).pop(); // 前の画面に戻る
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.isCallConnected.value) {
      // 通話待機画面
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.calleeUid} さんとの通話中...'),
        ),
        body: Center(
          child: Text('通話接続を待っています...'),
        ),
      );
    } else {
      // ビデオ通話画面
      return Scaffold(
        appBar: AppBar(
          title: Text('ビデオ通話 - ${controller.userId}'),
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
                          child: RTCVideoView(controller.localRenderer,
                              mirror: true),
                        ),
                        Expanded(
                          child: RTCVideoView(controller.remoteRenderer),
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
                  icon: Icon(controller.isMuted ? Icons.mic_off : Icons.mic),
                  onPressed: _onToggleMute,
                ),
                IconButton(
                  icon: Icon(controller.isCameraOff
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
