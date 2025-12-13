import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  LocationState copyWith({
    bool? loading,
    LatLng? position,
    String? address,
  }) {
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

    final permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) {
      state = state.copyWith(
        loading: false,
        address: "Location permission required",
      );
      return;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );

    final latLng = LatLng(position.latitude, position.longitude);

    state = state.copyWith(position: latLng);
    await _updateAddress(latLng);

    state = state.copyWith(loading: false);
  }

  Future<void> updatePosition(LatLng latLng) async {
    state = state.copyWith(position: latLng);
    await _updateAddress(latLng);
  }

  Future<void> _updateAddress(LatLng pos) async {
    try {
      final placemarks =
      await placemarkFromCoordinates(pos.latitude, pos.longitude);

      final p = placemarks.first;

      final address =
          "${p.name ?? ""}, ${p.street ?? ""}, ${p.locality ?? ""}, "
          "${p.administrativeArea ?? ""},${p.postalCode ?? ""}, ${p.country ?? ""}";

      state = state.copyWith(address: address);
    } catch (_) {
      state = state.copyWith(address: "Unable to fetch address");
    }
  }
}

final locationProvider =
StateNotifierProvider<LocationNotifier, LocationState>(
      (ref) => LocationNotifier(),
);
