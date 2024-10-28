import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleMapViewer extends StatefulWidget {
  const GoogleMapViewer({super.key});

  @override
  State<GoogleMapViewer> createState() => _GoogleMapViewerState();
}

class _GoogleMapViewerState extends State<GoogleMapViewer> {
  late GoogleMapController mapController;

  final LatLng _startPoint =
      const LatLng(35.681236, 139.767125); // Example: Tokyo Station
  final LatLng _endPoint =
      const LatLng(35.689487, 139.691711); // Example: Shinjuku Station

  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    String apiKey = dotenv.env['GOOGLE_MAP_API_KEY']!;
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_startPoint.latitude},${_startPoint.longitude}&destination=${_endPoint.latitude},${_endPoint.longitude}&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final points =
          _decodePolyline(data['routes'][0]['overview_polyline']['points']);
      setState(() {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
          ),
        );
      });
    } else {
      throw Exception('Failed to load directions');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }

    return poly;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Viewer'),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _startPoint,
          zoom: 11,
        ),
        polylines: _polylines,
        markers: {
          Marker(
            markerId: MarkerId('start'),
            position: _startPoint,
            infoWindow: InfoWindow(title: 'Start Point'),
          ),
          Marker(
            markerId: MarkerId('end'),
            position: _endPoint,
            infoWindow: InfoWindow(title: 'End Point'),
          ),
        },
      ),
    );
  }
}
