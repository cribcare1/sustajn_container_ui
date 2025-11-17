import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  State<MapSelectionScreen> createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _address = 'Select a location by tapping on the map';
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629), // Default to India center
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
      });

      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 10),
      );

      // Move camera to current location
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
      });
    } catch (e) {
      print('Location error: $e');
      setState(() {
        _isLoading = false;
      });
    }
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

        // Remove trailing comma
        address = address.replaceAll(RegExp(r',\s*$'), '');

        setState(() {
          _address = address.isNotEmpty ? address : 'Address not available';
          _searchController.text = address; // Update search field with address
        });
      } else {
        setState(() {
          _address = 'Address not available';
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Unable to get address';
      });
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng latLng = LatLng(location.latitude, location.longitude);

        if (_mapController != null) {
          await _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(latLng, 15),
          );
        }

        setState(() {
          _selectedLocation = latLng;
        });

        await _getAddressFromLatLng(latLng);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location not found: $query'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Try to get location again once map is created
    if (_selectedLocation == null) {
      _getCurrentLocation();
    }
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
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
                  BitmapDescriptor.hueRed,
                ),
                infoWindow: const InfoWindow(
                  title: 'Selected Location',
                ),
              ),
            }
                : {},
          ),

          // Search Bar
          // Positioned(
          //   top: 16,
          //   left: 16,
          //   right: 16,
          //   child: Card(
          //     elevation: 4,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          //       child: Row(
          //         children: [
          //           const Icon(Icons.search, color: Colors.grey),
          //           const SizedBox(width: 8),
          //           Expanded(
          //             child: TextField(
          //               controller: _searchController,
          //               decoration: const InputDecoration(
          //                 hintText: 'Search for an address...',
          //                 border: InputBorder.none,
          //                 contentPadding: EdgeInsets.symmetric(vertical: 12),
          //               ),
          //               onSubmitted: _searchLocation,
          //             ),
          //           ),
          //           if (_searchController.text.isNotEmpty)
          //             IconButton(
          //               icon: const Icon(Icons.clear, size: 20),
          //               onPressed: () {
          //                 setState(() {
          //                   _searchController.clear();
          //                 });
          //               },
          //             ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          // Loading Indicator
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading your location...',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Location Info Card
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Selected Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _address,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _confirmLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedLocation != null
                              ? Color(0xff6eac9e)
                              : Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Confirm Location',
                          style: TextStyle(
                            fontSize: 16,
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
    _searchController.dispose();
    super.dispose();
  }
}