import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:unicorn_flutter/Constants/Enum/unicorn_status_enum.dart';
import 'package:unicorn_flutter/Controller/Core/controller_core.dart';
import 'package:unicorn_flutter/Model/Data/User/user_data.dart';
import 'package:unicorn_flutter/Model/Entity/Emergency/emergency_request.dart';
import 'package:unicorn_flutter/Service/Api/Unicorn/unicorn_api.dart';
import 'package:unicorn_flutter/Service/Log/log_service.dart';
import 'package:unicorn_flutter/Service/Package/Location/location_service.dart';

class EmergencyController extends ControllerCore {
  LocationService get _locationService => LocationService();
  UnicornApi get _unicornApi => UnicornApi();

  late final ValueNotifier<UnicornStatusEnum> _emergencyStatus =
      ValueNotifier(UnicornStatusEnum.request);
  final ValueNotifier<bool> _wsConnectionStatus = ValueNotifier(false);

  @override
  void initialize() async {
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
        _emergencyStatus.value = UnicornStatusEnum.userWaiting;
      } catch (e) {
        Log.echo('Emergency Error: $e');
        _emergencyStatus.value = UnicornStatusEnum.failure;
      }
    });
    await _connectWebSocket();
  }

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
            callback: (StompFrame frame) {
              Log.echo('WebSocketCallback: ${frame.body}');
            },
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
}
