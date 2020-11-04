import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(41.150335, -8.557672),
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}