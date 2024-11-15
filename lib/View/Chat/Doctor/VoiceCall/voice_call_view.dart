import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/VoiceCall/voice_call_controller.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';

class VoiceCallView extends StatefulWidget {
  final String calleeUid;

  const VoiceCallView({super.key, required this.calleeUid});

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  late VoiceCallController _controller;
  Offset _localVideoOffset = const Offset(20, 20);

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
    const HomeRoute().go(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isCallConnected.value) {
      // 通話待機画面
      return CustomScaffold(
        appBar: AppBar(
          title: Text('${widget.calleeUid} さんとの通話中...'),
        ),
        body: const Center(
          child: Text('通話接続を待っています...'),
        ),
      );
    } else {
      // ビデオ通話画面
      return CustomScaffold(
        appBar: AppBar(
          title: Text('ビデオ通話 - ${_controller.userId}'),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.black.withOpacity(0.75),
            child: Stack(
              children: [
                Positioned.fill(
                  child: RTCVideoView(_controller.remoteRenderer),
                ),
                Positioned(
                  left: _localVideoOffset.dx,
                  top: _localVideoOffset.dy,
                  width: 100,
                  height: 150,
                  child: Draggable(
                    feedback: Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 4),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child:
                          RTCVideoView(_controller.localRenderer, mirror: true),
                    ),
                    childWhenDragging: Container(),
                    onDragEnd: (details) {
                      final dragDistance =
                          (details.offset - _localVideoOffset).distance;
                      if (dragDistance > 115) {
                        // Threshold to ignore minor taps
                        setState(() {
                          final newOffset = details.offset;
                          final screenHeight =
                              MediaQuery.of(context).size.height;
                          const bottomButtonHeight =
                              130.0; // Adjust this value as needed

                          if (newOffset.dy + 150 >
                              screenHeight - bottomButtonHeight) {
                            _localVideoOffset = Offset(newOffset.dx,
                                screenHeight - bottomButtonHeight - 150);
                          } else {
                            _localVideoOffset = newOffset;
                          }
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent, width: 4),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child:
                          RTCVideoView(_controller.localRenderer, mirror: true),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleButton(
                        icon: Icon(
                            _controller.isMuted ? Icons.mic_off : Icons.mic),
                        onTap: _onToggleMute,
                        buttonColor: Colors.white,
                        buttonSize: 64,
                        borderColor: Colors.grey,
                      ),
                      CircleButton(
                        icon: Icon(_controller.isCameraOff
                            ? Icons.videocam_off
                            : Icons.videocam),
                        onTap: _onToggleCamera,
                        buttonColor: Colors.white,
                        buttonSize: 64,
                        borderColor: Colors.grey,
                      ),
                      CircleButton(
                        icon: const Icon(Icons.call_end),
                        onTap: _onEndCall,
                        buttonColor: Colors.red,
                        buttonSize: 64,
                        borderColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
