// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:unicorn_flutter/Constants/Enum/emergency_status_enum.dart';
import 'package:unicorn_flutter/Constants/strings.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Emergency/WebSocket/unicorn_support.dart';
import 'package:unicorn_flutter/Model/Entity/Emergency/emergency_request.dart';
import 'package:unicorn_flutter/Route/router.dart';
import 'package:unicorn_flutter/Route/routes.dart';
import 'package:unicorn_flutter/Service/Api/Unicorn/unicorn_api.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/Location/location_service.dart';

class EmergencyController extends ControllerCore {
  LocationService get _locationService => LocationService();
  UnicornApi get _unicornApi => UnicornApi();

  EmergencyController(this.context);
  BuildContext context;

  bool isInitUnicornStartPoint = false;
  LatLng? unicornStartPoint;
  LatLng? userCurrentLocation;

  late StompClient stompClient;

  final ValueNotifier<EmergencyStatusEnum> _emergencyStatus =
      ValueNotifier(EmergencyStatusEnum.request);
  final ValueNotifier<bool> _wsConnectionStatus = ValueNotifier(false);
  final ValueNotifier<List<String>> _supportLog = ValueNotifier(<String>[]);
  final ValueNotifier<UnicornSupport?> _unicornSupport = ValueNotifier(null);

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

  ValueNotifier<List<String>> get supportLog => _supportLog;
  ValueNotifier<UnicornSupport?> get unicornSupport => _unicornSupport;

  /// ユーザーの現在地を取得
  Future<LatLng?> _getUserCurrentLocation() async {
    Position? position = await _locationService.getCurrentPosition();
    if (position == null) {
      return null;
    }
    return LatLng(position.latitude, position.longitude);
  }

  /// 位置情報から住所を取得
  Future<String?> getAddressFromLatLng(LatLng location) async {
    return await _locationService.getAddressFromLatLng(location);
  }

  /// API通信
  Future<int> _postEmergencyRequest() async {
    userCurrentLocation = await _getUserCurrentLocation();
    if (userCurrentLocation == null) {
      return 500;
    }
    EmergencyRequest emergencyRequest = EmergencyRequest(
      userId: UserData().user!.userId,
      userLatitude: userCurrentLocation!.latitude,
      userLongitude: userCurrentLocation!.longitude,
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

    stompClient = StompClient(
      config: StompConfig(
        url: wsUrl,
        onConnect: (StompFrame frame) async {
          Log.echo('WebSocket: Connected');
          _wsConnectionStatus.value = true;

          stompClient.subscribe(
            destination: destination,
            callback: _wsCallback,
          );
        },
        onWebSocketError: (dynamic error) {
          Log.echo('WebSocket: $error');
          _wsConnectionStatus.value = false;
        },
        onDisconnect: (StompFrame frame) {
          Log.echo('WebSocket: Disconnected');
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
  void _wsCallback(StompFrame frame) async {
    Log.echo('WebSocket Received: ${frame.body}');
    final Map<String, dynamic> json =
        jsonDecode(frame.body!) as Map<String, dynamic>;
    final EmergencyStatusEnum status =
        EmergencyStatusType.fromString(json['status']);
    _emergencyStatus.value = status;

    Log.echo('Emergency Status: $status');
    switch (status) {
      case EmergencyStatusEnum.allShutdown:
        _updateSupportLog(status);
        await Future.delayed(const Duration(seconds: 1));
        Fluttertoast.showToast(msg: Strings.UNICORN_NOT_FOUND_TEXT);
        const HomeRoute().go(context);
        break;
      case EmergencyStatusEnum.request:
        _updateSupportLog(status);
        break;
      case EmergencyStatusEnum.userWaiting:
        _updateSupportLog(status, waitingNumber: json['waitingNumber']);
        break;
      case EmergencyStatusEnum.dispatch:
        _unicornSupport.value = UnicornSupport.fromJson(json);
        _updateSupportLog(status);
        break;
      case EmergencyStatusEnum.moving:
        _unicornSupport.value = UnicornSupport.fromJson(json);
        _updateSupportLog(status);
        if (!isInitUnicornStartPoint) {
          isInitUnicornStartPoint = true;
          unicornStartPoint = LatLng(
            _unicornSupport.value!.robotLatitude!,
            _unicornSupport.value!.robotLongitude!,
          );
        }
        break;
      case EmergencyStatusEnum.arrival:
        _unicornSupport.value = UnicornSupport.fromJson(json);
        _updateSupportLog(status);
        await Future.delayed(const Duration(seconds: 3));
        const ProgressRoute(from: Routes.emergency).go(context);
        return;
      case EmergencyStatusEnum.complete:
        _unicornSupport.value = UnicornSupport.fromJson(json);
        _updateSupportLog(status);
        break;
      case EmergencyStatusEnum.failure:
        _updateSupportLog(status);
        break;
    }
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

  void dispose() {
    _wsConnectionStatus.removeListener(() {});
    _supportLog.dispose();
    _unicornSupport.dispose();
    _wsConnectionStatus.dispose();
    stompClient.deactivate();
  }
}
