import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/VoiceCall/voice_call_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Doctor/doctor.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';

class VoiceCallView extends StatefulWidget {
  final Doctor doctor;
  const VoiceCallView({super.key, required this.doctor});

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  late VoiceCallController _controller;
  Offset _localVideoOffset = const Offset(20, 100);
  bool _isSwapped = false;

  @override
  void initState() {
    super.initState();
    _controller = VoiceCallController(doctor: widget.doctor);
    _controller.isCallConnected.addListener(() {
      setState(() {});
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
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: '確認',
        bodyText: '医師との通話を終了しますか？',
        onTap: () {
          _controller.endCall();
          const HomeRoute().go(context);
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {}

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _localVideoOffset += details.delta;
      final screenHeight = MediaQuery.of(context).size.height;
      const bottomButtonHeight = 130.0;

      if (_localVideoOffset.dy + 150 > screenHeight - bottomButtonHeight) {
        _localVideoOffset = Offset(
          _localVideoOffset.dx,
          screenHeight - bottomButtonHeight - 150,
        );
      }
    });
  }

  void _onToggleSwap() {
    setState(() {
      _isSwapped = !_isSwapped;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isCallConnected.value) {
      return CustomScaffold(
        appBar: AppBar(
          title: Text(
              '${_controller.doctor.firstName} ${_controller.doctor.lastName} さんとの通話中...'),
        ),
        body: const Center(
          child: Text('通話接続を待っています...'),
        ),
      );
    } else {
      return CustomScaffold(
        isAppbar: false,
        appBar: AppBar(
          title: Text('ビデオ通話 - ${_controller.userId}'),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.black.withOpacity(0.75),
            child: Stack(
              children: [
                Positioned.fill(
                  child: _isSwapped
                      ? RTCVideoView(_controller.localRenderer, mirror: true)
                      : RTCVideoView(_controller.remoteRenderer),
                ),
                Positioned(
                  left: _localVideoOffset.dx,
                  top: _localVideoOffset.dy,
                  width: 100,
                  height: 150,
                  child: GestureDetector(
                    onPanStart: _onDragStart,
                    onPanUpdate: _onDragUpdate,
                    onTap: _onToggleSwap,
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
                      child: _isSwapped
                          ? RTCVideoView(_controller.remoteRenderer)
                          : RTCVideoView(_controller.localRenderer,
                              mirror: true),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text:
                            '${_controller.doctor.firstName} ${_controller.doctor.lastName} 先生',
                        color: Colors.white,
                        fontSize: 24,
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: _controller.elapsedTime,
                        builder: (context, value, child) {
                          return CustomText(
                            text: value,
                            color: Colors.white,
                            fontSize: 16,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(
                        _controller.isFrontCamera
                            ? Icons.camera_front
                            : Icons.camera_rear,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      _controller.switchCamera();
                      setState(() {});
                    },
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 64,
                        child: Column(
                          children: [
                            CircleButton(
                              icon: Icon(_controller.isMuted
                                  ? Icons.mic_off
                                  : Icons.mic),
                              onTap: _onToggleMute,
                              buttonColor: Colors.white,
                              buttonSize: 64,
                              borderColor: Colors.grey,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomText(
                              text: _controller.isMuted ? 'ミュート解除' : 'ミュート',
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 64,
                        child: Column(
                          children: [
                            CircleButton(
                              icon: const Icon(Icons.call_end,
                                  color: Colors.white),
                              onTap: _onEndCall,
                              buttonColor: Colors.red,
                              buttonSize: 64,
                              borderColor: Colors.grey,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const CustomText(
                              text: '通話終了',
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 64,
                        child: Column(
                          children: [
                            CircleButton(
                              icon: Icon(_controller.isCameraOff
                                  ? Icons.videocam_off
                                  : Icons.videocam),
                              onTap: _onToggleCamera,
                              buttonColor: Colors.white,
                              buttonSize: 64,
                              borderColor: Colors.grey,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            CustomText(
                              text: _controller.isCameraOff ? 'カメラオン' : 'カメラオフ',
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ],
                        ),
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
