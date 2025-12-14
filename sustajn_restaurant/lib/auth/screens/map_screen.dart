import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../auth_state/location_state.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  Completer<GoogleMapController> mapController = Completer();
  late BitmapDescriptor redMarker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationProvider);

    return SafeArea(
      top: false,bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
            title: "Select Restaurant Address",
            leading: CustomBackButton()).getAppBar(context),

        body: state.loading || state.position == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: state.position!,
                  zoom: 16,
                ),
                myLocationEnabled: false,
                myLocationButtonEnabled: true,

                markers: {
                  Marker(
                    markerId: const MarkerId("selected"),
                    position: state.position!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  )
                },

                onMapCreated: (controller) {
                  mapController.complete(controller);
                },

                onTap: (LatLng newPos) {
                  ref
                      .read(locationProvider.notifier)
                      .updatePosition(newPos);
                },

                onCameraIdle: () async {
                  final controller = await mapController.future;
                  LatLng center = await controller.getLatLng(
                    const ScreenCoordinate(x: 200, y: 350),
                  );
                  ref.read(locationProvider.notifier).updatePosition(center);
                },

                onCameraMove: (cameraPos) {
                  ref.read(locationProvider.notifier).updatePosition(
                    cameraPos.target,
                  );
                },
              ),
            ),

            // Address Box
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xff225343),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.location_pin, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.address,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Confirm Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: const Color(0xffe3b023),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    "lat": state.position!.latitude,
                    "lng": state.position!.longitude,
                    "address": state.address,
                  });
                },
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
