import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../constants/number_constants.dart';

class GoogleMapScreen extends StatefulWidget {
  final double destinationLat;
  final double destinationLng;
  final String restaurantName;
  final String address;

  const GoogleMapScreen({
    Key? key,
    required this.destinationLat,
    required this.destinationLng,
    required this.restaurantName,
    required this.address,
  }) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  bool _isLoading = true;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(40.7128, -74.0060), // Default to NYC
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _addMarkers();
        _isLoading = false;
      });
    });
  }

  void _addMarkers() {
    final destinationMarker = Marker(
      markerId: MarkerId('destination'),
      position: LatLng(widget.destinationLat, widget.destinationLng),
      infoWindow: InfoWindow(
        title: widget.restaurantName,
        snippet: widget.address,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(destinationMarker);
    });

    // Move camera to show both markers
    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(widget.destinationLat - 0.01, widget.destinationLng - 0.01),
          northeast: LatLng(widget.destinationLat + 0.01, widget.destinationLng + 0.01),
        ),
        Constant.CONTAINER_SIZE_50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Route to ${widget.restaurantName}',
          style: TextStyle(
            fontSize: Constant.LABEL_TEXT_SIZE_18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Constant.blueshade100,
        elevation: Constant.SIZE_02,
      ),
      body: Column(
        children: [
          // Restaurant Info Card
          Card(
            margin: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
            elevation: Constant.SIZE_02,
            child: Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurantName,
                    style: TextStyle(
                      fontSize: Constant.LABEL_TEXT_SIZE_18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_08),
                  Text(
                    widget.address,
                    style: TextStyle(
                      fontSize: Constant.LABEL_TEXT_SIZE_14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_08),
                  Text(
                    'Coordinates: ${widget.destinationLat.toStringAsFixed(4)}, ${widget.destinationLng.toStringAsFixed(4)}',
                    style: TextStyle(
                      fontSize: Constant.CONTAINER_SIZE_12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) {
                    setState(() {
                      _mapController = controller;
                    });
                  },
                  initialCameraPosition: _initialPosition,
                  markers: _markers,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  compassEnabled: true,
                  mapToolbarEnabled: true,
                ),
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Constant.blueshade100),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(widget.destinationLat, widget.destinationLng),
            ),
          );
        },
        backgroundColor: Constant.blueshade100,
        child: Icon(Icons.center_focus_strong, color: Colors.white),
      ),
    );
  }
}