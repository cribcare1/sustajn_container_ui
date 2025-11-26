import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../constants/number_constants.dart';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _address = 'Getting your current location...';
  bool _isLoading = true;
  bool _isCurrentLocation = true;
  bool _locationServiceAvailable = true;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629),
    zoom: 4,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      setState(() {
        _isLoading = true;
        _address = 'Getting your current location...';
      });

      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setDefaultLocation();
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _setDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setDefaultLocation();
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 15),
      );

      final currentLatLng = LatLng(position.latitude, position.longitude);
      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentLatLng, 15),
        );
      }

      // Get address for current location
      await _getAddressFromLatLng(currentLatLng);

      setState(() {
        _selectedLocation = currentLatLng;
        _isLoading = false;
        _isCurrentLocation = true;
        _locationServiceAvailable = true;
      });
    } catch (e) {
      print('Location error: $e');
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
    final defaultLatLng = LatLng(20.5937, 78.9629);
    setState(() {
      _selectedLocation = defaultLatLng;
      _isLoading = false;
      _isCurrentLocation = true;
      _locationServiceAvailable = false;
      _address = 'Default Location: India';
    });

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(defaultLatLng, 5),
      );
    }

    _getAddressFromLatLng(defaultLatLng);
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String street = place.street ?? '';
        String locality = place.locality ?? '';
        String administrativeArea = place.administrativeArea ?? '';
        String country = place.country ?? '';
        String postalCode = place.postalCode ?? '';

        String address = '';
        if (street.isNotEmpty) address += '$street, ';
        if (locality.isNotEmpty) address += '$locality, ';
        if (administrativeArea.isNotEmpty) address += '$administrativeArea, ';
        if (postalCode.isNotEmpty) address += '$postalCode, ';
        if (country.isNotEmpty) address += country;

        address = address.replaceAll(RegExp(r',\s*$'), '');

        setState(() {
          _address = address.isNotEmpty ? address : 'Address not available';
        });
      }
    } catch (e) {
      print('Geocoding error: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    if (_selectedLocation == null) {
      _getCurrentLocation();
    } else {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_selectedLocation!, 15),
      );
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _isCurrentLocation = false;
      _address = 'Getting address...';
    });
    _getAddressFromLatLng(latLng);
  }

  void _confirmLocation() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _address);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location on the map'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: Color(0xff6eac9e),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: _initialPosition,
            onTap: _onMapTap,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: const MarkerId('selected_location'),
                position: _selectedLocation!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  _isCurrentLocation ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
                ),
                infoWindow: InfoWindow(
                  title: _isCurrentLocation ? 'Current Location' : 'Selected Location',
                ),
              ),
            }
                : {},
          ),

          // Loading Indicator
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: Constant.CONTAINER_SIZE_16),
                   Text(
                    'Loading your location...',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: Constant.LABEL_TEXT_SIZE_16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Location Info Card
          Positioned(
            bottom: Constant.CONTAINER_SIZE_20,
            left: Constant.CONTAINER_SIZE_20,
            right: Constant.CONTAINER_SIZE_20,
            child: Card(
              elevation: Constant.SIZE_08,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.LABEL_TEXT_SIZE_16),
              ),
              child: Padding(
                padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: _isCurrentLocation ? Colors.green : Colors.blue.shade700,
                          size: Constant.CONTAINER_SIZE_20,
                        ),
                         SizedBox(width: Constant.SIZE_08),
                        Text(
                          _isCurrentLocation ? 'Current Location' : 'Selected Location',
                          style: TextStyle(
                            fontSize: Constant.LABEL_TEXT_SIZE_16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                     SizedBox(height: Constant.CONTAINER_SIZE_12),
                    Text(
                      _address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      maxLines: Constant.MAX_LINE_3,
                      overflow: TextOverflow.ellipsis,
                    ),
                     SizedBox(height: Constant.CONTAINER_SIZE_20),
                    SizedBox(
                      width: double.infinity,
                      height: Constant.CONTAINER_SIZE_50,
                      child: ElevatedButton(
                        onPressed: _confirmLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedLocation != null
                              ? Color(0xff6eac9e)
                              : Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          elevation: Constant.SIZE_02,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                          ),
                        ),
                        child:  Text(
                          'Confirm Location',
                          style: TextStyle(
                            fontSize: Constant.CONTAINER_SIZE_16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}