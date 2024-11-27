import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/VoiceCall/voice_call_controller.dart';
import 'package:unicorn_flutter/Model/Entity/Call/call.dart';
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

  void _onToggleCamera() {
    setState(() {
      _controller.toggleCamera();
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
        customButtonCount: 2,
        rightButtonText: '終了',
        rightButtonOnTap: () {
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

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _controller.localPreviewPos += details.delta;
      final double screenHeight = MediaQuery.of(context).size.height - 64;
      final double screenWidth = MediaQuery.of(context).size.width;
      if (_controller.localPreviewPos.dx < 0) {
        _controller.localPreviewPos = Offset(0, _controller.localPreviewPos.dy);
      }
      if (_controller.localPreviewPos.dx > screenWidth - 100) {
        _controller.localPreviewPos =
            Offset(screenWidth - 100, _controller.localPreviewPos.dy);
      }
      if (_controller.localPreviewPos.dy < 0) {
        _controller.localPreviewPos = Offset(_controller.localPreviewPos.dx, 0);
      }
      if (_controller.localPreviewPos.dy > screenHeight - 150) {
        _controller.localPreviewPos =
            Offset(_controller.localPreviewPos.dx, screenHeight - 150);
      }
    });
  }

  /// カメラがオフの場合のビュー
  /// [isLocal] 自分のカメラか
  /// [isMinimized] ミニマイズビューか
  Widget _cameraDisabledView({
    required bool isLocal,
    required bool isMinimized,
  }) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off_rounded,
              color: Colors.white,
              size: isMinimized ? 24 : 48,
            ),
            if (!isMinimized) ...[
              const SizedBox(height: 8),
              CustomText(
                text: '${isLocal ? 'カメラ' : '相手の映像'}がオフになっています',
                color: Colors.white,
              ),
            ]
          ],
        ),
      ),
    );
  }

  /// 自分のカメラビュー
  /// [isMinimized] ミニマイズビューか
  Widget _buildAgoraVideoLocal({bool isMinimized = false}) {
    return ValueListenableBuilder(
      valueListenable: _controller.isLocalCameraEnabled,
      builder: (context, value, child) {
        if (!value) {
          return _cameraDisabledView(isLocal: true, isMinimized: isMinimized);
        }

        return AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _controller.engine,
            canvas: const VideoCanvas(uid: 0),
            useFlutterTexture: true,
            useAndroidSurfaceView: true,
          ),
          onAgoraVideoViewCreated: (viewId) {
            _controller.engine.startPreview();
          },
        );
      },
    );
  }

  /// 相手のカメラビュー
  /// [isMinimized] ミニマイズビューか
  Widget _buildAgoraVideoRemote({bool isMinimized = false}) {
    return ValueListenableBuilder(
      valueListenable: _controller.isRemoteCameraEnabled,
      builder: (context, value, child) {
        if (!value) {
          return _cameraDisabledView(isLocal: false, isMinimized: isMinimized);
        }

        return AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _controller.engine,
            canvas: VideoCanvas(uid: _controller.uid),
            useFlutterTexture: true,
            useAndroidSurfaceView: true,
            connection:
                RtcConnection(channelId: _controller.call.callReservationId),
          ),
        );
      },
    );
  }

  /// イベントハンドラボタン
  /// [icon] アイコン
  /// [iconColor] アイコンの色
  /// [label] ラベル
  /// [buttonColor] ボタンの色
  /// [onTap] タップ時の処理
  SizedBox _eventHandlerButton({
    required IconData icon,
    Color? iconColor,
    required String label,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 64,
      child: Column(
        children: [
          CircleButton(
            icon: Icon(icon, color: iconColor),
            onTap: onTap,
            buttonColor: buttonColor,
            buttonSize: 64,
            borderColor: Colors.grey,
          ),
          const SizedBox(
            height: 6,
          ),
          CustomText(
            text: label,
            fontSize: 10,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isUserJoined.value) {
      return CustomScaffold(
        appBar: CustomAppBar(title: '通話待機中...'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingAnimationWidget.fourRotatingDots(
                color: Colors.amber,
                size: 54,
              ),
              const SizedBox(height: 16),
              const CustomText(text: '通話接続を待っています...'),
              const SizedBox(height: 256),
              CustomButton(
                text: 'キャンセル',
                onTap: () => _controller.endCall(),
              ),
            ],
          ),
        ),
      );
    } else {
      return CustomScaffold(
        isAppbar: false,
        body: SafeArea(
          child: Container(
            color: Colors.black.withOpacity(0.75),
            child: Stack(
              children: [
                _controller.isSwapped
                    ? _buildAgoraVideoLocal()
                    : _buildAgoraVideoRemote(),
                Positioned(
                  left: _controller.localPreviewPos.dx,
                  top: _controller.localPreviewPos.dy,
                  width: 100,
                  height: 150,
                  child: GestureDetector(
                    onPanUpdate: _onDragUpdate,
                    onTap: _onToggleSwap,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                      ),
                      child: _controller.isSwapped
                          ? _buildAgoraVideoRemote(isMinimized: true)
                          : _buildAgoraVideoLocal(isMinimized: true),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text:
                                '${_controller.doctor?.lastName ?? ''} ${_controller.doctor?.firstName ?? ''} 先生',
                            color: Colors.white,
                            fontSize: 24,
                          ),
                          ValueListenableBuilder(
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
                      const SizedBox(width: 16),
                      ValueListenableBuilder(
                        valueListenable: _controller.isRemoteMutated,
                        builder: (context, value, child) {
                          return value
                              ? const Icon(
                                  Icons.mic_off,
                                  color: Colors.red,
                                )
                              : const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 20,
                  child: GestureDetector(
                    onTap: () => _onSwitchCamera(),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 72,
                      width: 72,
                      alignment: Alignment.center,
                      child: Icon(
                        _controller.useFrontCamera
                            ? Icons.camera_front
                            : Icons.camera_rear,
                        color: Colors.white,
                        size: 30,
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
                      _eventHandlerButton(
                        icon: _controller.isMuted ? Icons.mic_off : Icons.mic,
                        label: _controller.isMuted ? 'ミュート解除' : 'ミュート',
                        buttonColor: Colors.white,
                        onTap: _onToggleMute,
                      ),
                      _eventHandlerButton(
                        icon: Icons.call_end,
                        label: '通話終了',
                        buttonColor: Colors.red,
                        iconColor: Colors.white,
                        onTap: _onEndCall,
                      ),
                      _eventHandlerButton(
                        icon: _controller.isLocalCameraEnabled.value
                            ? Icons.videocam_off
                            : Icons.videocam,
                        label: _controller.isLocalCameraEnabled.value
                            ? 'カメラオフ'
                            : 'カメラオン',
                        buttonColor: Colors.white,
                        onTap: _onToggleCamera,
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
