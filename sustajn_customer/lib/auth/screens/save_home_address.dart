import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../notifier/location_state.dart';
import '../../utils/theme_utils.dart';

class HomeAddress extends ConsumerStatefulWidget {
  const HomeAddress({super.key});

  @override
  ConsumerState<HomeAddress> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<HomeAddress> {
  final Completer<GoogleMapController> _controller = Completer();

  int selectedSaveAs = 0;
  final searchController = TextEditingController();

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
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: "Select Home Address",
          leading: CustomBackButton(),
        ).getAppBar(context),

        body: state.loading || state.position == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [

            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTheme.searchField(
                searchController,
                'Search by restaurant name',
              ),
            ),

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

                  const Center(
                    child: Icon(
                      Icons.location_pin,
                      size: 44,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xff0f3d2e),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Constant.gold),
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
                    ),
                    child: const Center(
                      child: Text(
                        "Use Current Location",
                        style: TextStyle(
                          color: Constant.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Constant.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Constant.grey.withOpacity(0.1)
                      )
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

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      _saveAsChip("Home", 0),
                      const SizedBox(width: 8),
                      _saveAsChip("Work", 1),
                      const SizedBox(width: 8),
                      _saveAsChip("Other", 2),
                    ],
                  ),

                  if (selectedSaveAs == 2) ...[
                    const SizedBox(height: 12),
                    _inputField("Save as"),
                  ],

                  const SizedBox(height: 12),
                  _inputField("Flat / Door / House"),
                  const SizedBox(height: 12),
                  _inputField("Street / Block / City / Postal Code"),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffe3b023),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding:  EdgeInsets.symmetric(vertical: Constant.CONTAINER_SIZE_12),
                      ),

                      onPressed: () {
                        Navigator.pop(context, {
                          "lat": state.position!.latitude,
                          "lng": state.position!.longitude,
                          "address": state.address,
                        });
                      },
                      child:  Text(
                        "Confirm & Continue",
                        style: TextStyle(
                          color:theme.scaffoldBackgroundColor ,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _saveAsChip(String text, int index) {
    final isSelected = selectedSaveAs == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSaveAs = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xffe3b023)
                : const Color(0xff1b4d3a),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hint) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          borderSide: BorderSide(color: Constant.grey),
        ),
        enabledBorder: CustomTheme.roundedBorder(Constant.grey),
        focusedBorder: CustomTheme.roundedBorder(Constant.grey),
      ),
    );
  }
}
