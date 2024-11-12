import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:unicorn_flutter/Controller/Chat/Doctor/VoiceCall/voice_call_controller.dart';

class VoiceCallView extends StatefulWidget {
  const VoiceCallView({super.key});

  @override
  State<VoiceCallView> createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  late VoiceCallController controller;

  @override
  void initState() {
    super.initState();
    controller = VoiceCallController();
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
    setState(() {
      controller.endCall();
    });
  }

  void _onCreateOffer() {
    controller.createOffer(() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('接続する相手を選択してください。')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter WebRTC Demo - ${controller.userId}'),
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
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<List<String>>(
                          stream: controller.peersController.stream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            snapshot.data!.removeWhere(
                                (element) => element == controller.userId);
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Text('利用可能な相手がいません');
                            }
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final peer = snapshot.data![index];
                                final isSelected =
                                    peer == controller.selectedPeer;
                                return ListTile(
                                  title: Text(
                                    peer,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),
                                  tileColor:
                                      isSelected ? Colors.green[100] : null,
                                  onTap: isSelected
                                      ? null
                                      : () {
                                          setState(() {
                                            controller.selectedPeer = peer;
                                          });
                                          _onCreateOffer();
                                        },
                                );
                              },
                            );
                          },
                        ),
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
