import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:unicorn_flutter/Constants/Enum/emergency_status_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Emergency/WebSocket/unicorn_support.dart';
import 'package:unicorn_flutter/Model/Entity/Emergency/emergency_request.dart';
import 'package:unicorn_flutter/Service/Api/Unicorn/unicorn_api.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/Location/location_service.dart';

class EmergencyController extends ControllerCore {
  LocationService get _locationService => LocationService();
  UnicornApi get _unicornApi => UnicornApi();

  final ValueNotifier<EmergencyStatusEnum> _emergencyStatus =
      ValueNotifier(EmergencyStatusEnum.request);
  final ValueNotifier<bool> _wsConnectionStatus = ValueNotifier(false);
  final ValueNotifier<bool> _useMap = ValueNotifier(false);
  final ValueNotifier<List<String>> _supportLog = ValueNotifier(<String>[]);

  @override
  void initialize() async {
    _emergencyStatus.value = EmergencyStatusEnum.request;
    _updateSupportLog(_emergencyStatus.value);

    _listenWsConnectionStatus((value) async {
      try {
        Log.echo('WebSocketConnectionStatus: $value');
        if (!value) {
          throw Exception('WebSocket Connection Error');
        }
        // [API] Unicornを要請
        final int statusCode = await _postEmergencyRequest();
        Log.echo('Emergency Request Status: $statusCode');
        if (statusCode != 200) {
          throw Exception('Emergency Request Error');
        }
      } catch (e) {
        Log.echo('Emergency Error: $e');
        _emergencyStatus.value = EmergencyStatusEnum.failure;
        _updateSupportLog(_emergencyStatus.value);
      }
    });

    await _connectWebSocket();
  }

  ValueNotifier<bool> get useMap => _useMap;
  ValueNotifier<List<String>> get supportLog => _supportLog;

  /// ユーザーの現在地を取得
  Future<LatLng?> _getUserCurrentLocation() async {
    Position? position = await _locationService.getCurrentPosition();
    if (position == null) {
      return null;
    }
    return LatLng(position.latitude, position.longitude);
  }

  /// API通信
  Future<int> _postEmergencyRequest() async {
    LatLng? userCurrentLocation = await _getUserCurrentLocation();
    if (userCurrentLocation == null) {
      return 500;
    }
    EmergencyRequest emergencyRequest = EmergencyRequest(
      userId: UserData().user!.userId,
      userLatitude: userCurrentLocation.latitude,
      userLongitude: userCurrentLocation.longitude,
    );
    final int statusCode = await _unicornApi.postEmergency(
      body: emergencyRequest,
    );
    return statusCode;
  }

  /// WebSocket接続
  Future<void> _connectWebSocket() async {
    String wsUrl =
        '${dotenv.env['UNICORN_API_BASEURL']!.replaceFirst(RegExp('https'), 'ws')}/ws';
    final String destination =
        '/topic/unicorn/users/${UserData().user!.userId}';

    late StompClient stompClient;
    stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (StompFrame frame) async {
          Log.echo('WebSocket: Connected');
          _wsConnectionStatus.value = true;

          stompClient.subscribe(
            destination: destination,
            callback: wsCallback,
          );
        },
        onWebSocketError: (dynamic error) {
          Log.echo('WebSocket: $error');
          _wsConnectionStatus.value = false;
        },
        onDisconnect: (StompFrame frame) {
          Log.echo('WebSocket: Disconnected');
          _wsConnectionStatus.value = false;
        },
      ),
    );
    stompClient.activate();
  }

  /// WebSocketの状態をListen
  void _listenWsConnectionStatus(ValueChanged<bool> callback) {
    _wsConnectionStatus.addListener(() {
      callback(_wsConnectionStatus.value);
    });
  }

  /// destinationからのコールバック関数
  void wsCallback(StompFrame frame) {
    Log.echo('WebSocket Received: ${frame.body}');
    final Map<String, dynamic> json =
        jsonDecode(frame.body!) as Map<String, dynamic>;
    final EmergencyStatusEnum status =
        EmergencyStatusType.fromString(json['status']);
    _emergencyStatus.value = status;

    UnicornSupport? unicornSupport;
    int? waitingNumber;
    Log.echo('Emergency Status: $status');
    switch (status) {
      case EmergencyStatusEnum.request:
        break;
      case EmergencyStatusEnum.userWaiting:
        waitingNumber = json['waitingNumber'];
        break;
      case EmergencyStatusEnum.dispatch:
        unicornSupport = UnicornSupport.fromJson(json);
        break;
      case EmergencyStatusEnum.moving:
        unicornSupport = UnicornSupport.fromJson(json);
        _useMap.value = true;
        break;
      case EmergencyStatusEnum.arrival:
        unicornSupport = UnicornSupport.fromJson(json);
        break;
      case EmergencyStatusEnum.complete:
        unicornSupport = UnicornSupport.fromJson(json);
        break;
      case EmergencyStatusEnum.failure:
        break;
    }
    _updateSupportLog(status, waitingNumber: waitingNumber);
  }

  /// サポートログを更新
  /// [status] 現在の状態
  void _updateSupportLog(EmergencyStatusEnum status, {int? waitingNumber}) {
    final String now = DateFormat('HH:mm:ss').format(DateTime.now());
    final String log = EmergencyStatusType.toLogString(status);
    final String waitingLog =
        waitingNumber != null ? '($waitingNumber人待ち)' : '';
    _supportLog.value = List.from(_supportLog.value)
      ..add('[$now] $log $waitingLog');
  }
}
