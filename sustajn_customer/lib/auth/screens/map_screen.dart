import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../notifier/location_state.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

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
            leading: CustomBackButton()
        ).getAppBar(context),
        body: state.loading || state.position == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: state.position!,
                      zoom: 17,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: false,
                    compassEnabled: true,
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                    onCameraIdle: () async {
                      final controller = await _controller.future;
                      final bounds =
                      await controller.getVisibleRegion();

                      final center = LatLng(
                        (bounds.northeast.latitude +
                            bounds.southwest.latitude) /
                            2,
                        (bounds.northeast.longitude +
                            bounds.southwest.longitude) /
                            2,
                      );

                      ref
                          .read(locationProvider.notifier)
                          .updatePosition(center);
                    },
                  ),

                  // 🔴 CENTER PIN (Google Maps Style)
                  const Center(
                    child: Icon(
                      Icons.location_pin,
                      size: 42,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            // ADDRESS
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xff225343),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        state.address,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // CONFIRM
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffe3b023),
                  minimumSize: const Size(double.infinity, 50),
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