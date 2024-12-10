import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:unicorn_flutter/Service/Log/log_service.dart';

class GoogleMapViewer extends StatefulWidget {
  const GoogleMapViewer({
    super.key,
    required this.point,
    this.destination,
    this.current,
  });
  final LatLng point;
  final LatLng? destination;
  final LatLng? current;

  @override
  State<GoogleMapViewer> createState() => _GoogleMapViewerState();
}

class _GoogleMapViewerState extends State<GoogleMapViewer> {
  GoogleMapController? mapController;

  late LatLng _point;
  late LatLng? _destination;
  late LatLng? _current;

  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _point = widget.point;
    _destination = widget.destination;
    _current = widget.current;

    if (_destination != null) {
      _fetchRoute();
    }
  }

  @override
  void didUpdateWidget(GoogleMapViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.point != oldWidget.point ||
        widget.destination != oldWidget.destination ||
        widget.current != oldWidget.current) {
      setState(() {
        _point = widget.point;
        _destination = widget.destination;
        _current = widget.current;
        _polylines.clear();
      });
      if (_destination != null) {
        _fetchRoute();
        _animateCameraToBounds();
      } else {
        try {
          mapController?.animateCamera(
            CameraUpdate.newLatLng(_point),
          );
        } catch (e) {
          Log.echo('Error: $e');
        }
      }
    }
  }

  Future<void> _fetchRoute() async {
    String apiKey = dotenv.env['GOOGLE_MAP_API_KEY']!;
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_point.latitude},${_point.longitude}&destination=${_destination!.latitude},${_destination!.longitude}&key=$apiKey'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load directions');
    }
    final data = json.decode(response.body);
    final points =
        _decodePolyline(data['routes'][0]['overview_polyline']['points']);

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: Colors.blue,
        width: 5,
      ),
    );
    setState(() {});
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
    if (_destination != null) {
      _animateCameraToBounds();
    } else {
      controller.animateCamera(
        CameraUpdate.newLatLng(_point),
      );
    }
  }

  void _animateCameraToBounds() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        [
          _point.latitude,
          _destination!.latitude,
          _current?.latitude ?? _point.latitude
        ].reduce((a, b) => a < b ? a : b),
        [
          _point.longitude,
          _destination!.longitude,
          _current?.longitude ?? _point.longitude
        ].reduce((a, b) => a < b ? a : b),
      ),
      northeast: LatLng(
        [
          _point.latitude,
          _destination!.latitude,
          _current?.latitude ?? _point.latitude
        ].reduce((a, b) => a > b ? a : b),
        [
          _point.longitude,
          _destination!.longitude,
          _current?.longitude ?? _point.longitude
        ].reduce((a, b) => a > b ? a : b),
      ),
    );
    try {
      mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50),
      );
    } catch (e) {
      Log.echo('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: true,
      child: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _point,
          zoom: _destination == null ? 14 : 11,
        ),
        polylines: _polylines,
        markers: {
          Marker(
            markerId: const MarkerId('point'),
            position: _point,
            infoWindow: const InfoWindow(title: 'Start Point'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
          if (_destination != null)
            Marker(
              markerId: const MarkerId('destination'),
              position: _destination!,
              infoWindow: const InfoWindow(title: 'Destination'),
            ),
          if (_current != null)
            Marker(
              markerId: const MarkerId('current'),
              position: _current!,
              infoWindow: const InfoWindow(title: 'Current Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta),
            ),
        },
      ),
    );
  }
}
