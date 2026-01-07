import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';

import '../../utils/theme_utils.dart';
import '../auth_state/location_state.dart';

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

  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationProvider);
    final theme = Theme.of(context);
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Select Restaurant Address",
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ).getAppBar(context),
        body: state.loading || state.position == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.5,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: state.position!,
                          zoom: 17,
                        ),
                        markers: state.position == null
                            ? {}
                            : {
                                Marker(
                                  markerId: const MarkerId('selected_location'),
                                  position: state.position!,
                                ),
                              },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: false,
                        compassEnabled: true,
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (latLng) {
                          ref
                              .read(locationProvider.notifier)
                              .updatePosition(latLng);
                        },

                        onCameraIdle: () async {
                          final controller = await _controller.future;
                          final bounds = await controller.getVisibleRegion();

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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: theme!.secondaryHeaderColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                              ),
                              icon: Icon(
                                Icons.my_location,
                                color: theme!.secondaryHeaderColor,
                              ),
                              label: Text(
                                'Use Current Location',
                                style: TextStyle(
                                  color: theme!.secondaryHeaderColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: () async {
                                await ref
                                    .read(locationProvider.notifier)
                                    .initialize();
                                final pos = ref.read(locationProvider).position;
                                if (pos == null) return;
                                final controller = await _controller.future;
                                controller.animateCamera(
                                  CameraUpdate.newLatLngZoom(pos, 17),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_16),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xff225343),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                ),
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
                          SizedBox(height: Constant.CONTAINER_SIZE_16),
                          CustomTheme.textField(
                            isSearch: false,
                            addressController,
                            "Enter Restaurant address",
                            maxLine: 3,
                          ),
                        ],
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
                            "address":
                                "${addressController.text.isNotEmpty ? "${addressController.text}," : ""} ${state.address}",
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
      ),
    );
  }
}
