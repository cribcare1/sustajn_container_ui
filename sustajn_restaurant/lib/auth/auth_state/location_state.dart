import 'package:flutter_riverpod/legacy.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationState {
  final bool loading;
  final LatLng? position;
  final String address;
  final String? error;

  LocationState({
    this.loading = false,
    this.position,
    this.address = "",
    this.error,
  });

  LocationState copyWith({
    bool? loading,
    LatLng? position,
    String? address,
    String? error,
  }) {
    return LocationState(
      loading: loading ?? this.loading,
      position: position ?? this.position,
      address: address ?? this.address,
      error: error,
    );
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  GoogleMapController? mapController;

  void setMapController(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> initialize() async {
    state = state.copyWith(loading: true, error: null);

    final permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) {
      state = state.copyWith(
        loading: false,
        error: "Location permission required",
        address: "Location permission required",
      );
      return;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    }
try{
  final position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
  );

  final latLng = LatLng(position.latitude, position.longitude);

  state = state.copyWith(position: latLng);
  await _updateAddress(latLng);
  if (mapController != null) {
    mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 15),
    );
  }

  state = state.copyWith(loading: false);
}catch(e){
  state = state.copyWith(
    loading: false,
    error: "Failed to get current location: $e",
  );
}
  }

  Future<void> searchAddress(String searchQuery) async {
    if (searchQuery.isEmpty) return;

    state = state.copyWith(loading: true, error: null);

    try {
      final locations = await locationFromAddress(searchQuery);

      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);

        state = state.copyWith(position: latLng);
        await _updateAddress(latLng);
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(latLng, 15),
          );
        }

        state = state.copyWith(loading: false);
      } else {
        state = state.copyWith(
          loading: false,
          error: "Location not found",
        );
      }
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: "Failed to search location: $e",
      );
    }
  }

  Future<void> updatePosition(LatLng latLng) async {
    state = state.copyWith(position: latLng, loading: true);
    await _updateAddress(latLng);
    state = state.copyWith(loading: false);
  }
  Future<void> onMapTap(LatLng latLng) async {
    state = state.copyWith(position: latLng, loading: true);
    await _updateAddress(latLng);
    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    }

    state = state.copyWith(loading: false);

  }

  Future<void> _updateAddress(LatLng pos) async {
    try {
      final placemarks =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        final address = [
          p.name,
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.postalCode,
          p.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        state = state.copyWith(address: address);
      }
    } catch (e) {
      state = state.copyWith(address: "Unable to fetch address");
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

}

final locationProvider =
StateNotifierProvider<LocationNotifier, LocationState>(
      (ref) => LocationNotifier(),
);
