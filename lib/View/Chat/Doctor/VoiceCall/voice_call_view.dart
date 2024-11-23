import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/VoiceCall/voice_call_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_appbar.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_button.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_dialog.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_scaffold.dart';
import 'package:unicorn_flutter/View/Component/CustomWidget/custom_text.dart';
import 'package:unicorn_flutter/View/Component/Parts/circle_button.dart';

class VoiceCallView extends StatefulWidget {
  final Call call;
  const VoiceCallView({super.key, required this.call});

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  late VoiceCallController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VoiceCallController(call: widget.call, context: context);
    _controller.isUserJoined.addListener(() {
      Log.echo('isChannelJoined: ${_controller.isUserJoined.value}');
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

  void _onSwitchCamera() {
    setState(() {
      _controller.switchCamera();
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
        },
      ),
    );
  }

  void _onToggleSwap() {
    setState(() {
      _controller.toggleSwap();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isUserJoined.value) {
      return CustomScaffold(
        // appBar: CustomAppBar(
        //     title:
        //         '${_controller.doctor.firstName} ${_controller.doctor.lastName} 先生との通話待機中...'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              const CustomText(text: '通話接続を待っています...'),
              const SizedBox(height: 256),
              CustomButton(
                text: 'キャンセル',
                onTap: () {
                  _controller.endCall();
                  const HomeRoute().go(context);
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return CustomScaffold(
        isAppbar: false,
        body: SafeArea(
          child: Stack(
            children: [
              _controller.isSwapped
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _controller.engine,
                        canvas: const VideoCanvas(uid: 0),
                        useFlutterTexture: true,
                        useAndroidSurfaceView: true,
                      ),
                      onAgoraVideoViewCreated: (viewId) {
                        _controller.engine.startPreview();
                      },
                    )
                  : AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _controller.engine,
                        canvas: VideoCanvas(uid: _controller.uid),
                        useFlutterTexture: true,
                        useAndroidSurfaceView: true,
                        connection: RtcConnection(
                            channelId: _controller.call.callReservationId),
                      ),
                    ),
              Positioned(
                left: 20,
                top: 100,
                width: 100,
                height: 150,
                child: GestureDetector(
                  onTap: _onToggleSwap,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    child: _controller.isSwapped
                        ? AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: _controller.engine,
                              canvas: VideoCanvas(uid: _controller.uid),
                              useFlutterTexture: true,
                              useAndroidSurfaceView: true,
                              connection: RtcConnection(
                                  channelId:
                                      _controller.call.callReservationId),
                            ),
                          )
                        : AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _controller.engine,
                              canvas: const VideoCanvas(uid: 0),
                              useFlutterTexture: true,
                              useAndroidSurfaceView: true,
                            ),
                            onAgoraVideoViewCreated: (viewId) {
                              _controller.engine.startPreview();
                            },
                          ),
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
                      icon: _controller.isMuted
                          ? const Icon(Icons.mic_off)
                          : const Icon(Icons.mic),
                      onTap: _onToggleMute,
                      buttonColor:
                          _controller.isMuted ? Colors.red : Colors.blueAccent,
                      buttonSize: 48,
                    ),
                    CircleButton(
                      icon: const Icon(Icons.call_end),
                      onTap: _onEndCall,
                      buttonColor: Colors.red,
                      buttonSize: 48,
                    ),
                    CircleButton(
                      icon: const Icon(Icons.switch_camera),
                      onTap: _onSwitchCamera,
                      buttonColor: Colors.blueAccent,
                      buttonSize: 48,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
