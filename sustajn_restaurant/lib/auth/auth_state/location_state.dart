import 'package:flutter_riverpod/legacy.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationState {
  final bool loading;
  final LatLng? position;
  final String address;

  LocationState({
    this.loading = false,
    this.position,
    this.address = "",
  });

  LocationState copyWith({bool? loading, LatLng? position, String? address}) {
    return LocationState(
      loading: loading ?? this.loading,
      position: position ?? this.position,
      address: address ?? this.address,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  Future<void> initialize() async {
    state = state.copyWith(loading: true);

    // Check permission
    var permission = await Permission.location.request();
    if (permission != PermissionStatus.granted) {
      state = state.copyWith(loading: false, address: "Please enable location permission");
      return;
    }

    final serviceEnabled = await Permission.location.serviceStatus.isEnabled;
    if (!serviceEnabled) {
      state = state.copyWith(loading: false, address: "Please turn ON location service");
      return;
    }

    // Get current location
    final pos = await Geolocator.getCurrentPosition();
    final currentLatLng = LatLng(pos.latitude, pos.longitude);

    state = state.copyWith(position: currentLatLng);

    await _updateAddress(currentLatLng);

    state = state.copyWith(loading: false);
  }

  Future<void> updatePosition(LatLng newPos) async {
    state = state.copyWith(position: newPos);
    await _updateAddress(newPos);
  }

  Future<void> _updateAddress(LatLng pos) async {
    try {
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final p = placemarks.first;

      final address =
          "${p.name}, ${p.street}, ${p.locality}, ${p.administrativeArea}, ${p.country}";

      state = state.copyWith(address: address);
    } catch (e) {
      state = state.copyWith(address: "Unable to fetch address");
    }
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
      (ref) => LocationNotifier(),
);
