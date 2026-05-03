import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../../provider/profile_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../auth_state/location_state.dart';

class MapScreen extends ConsumerStatefulWidget {
  final String? profile;

  const MapScreen({
    super.key,
    this.profile = "",
  });

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController addressController =
  TextEditingController();

  final TextEditingController searchController =
  TextEditingController();

  GoogleMapController? _mapController;

  final Set<Marker> _markers = {};

  Timer? _debounce;

  bool _showMap = true;

  String _initialAddress = "";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(locationProvider.notifier)
          .initialize();

      final state = ref.read(locationProvider);

      if (state.position != null) {
        _setMarker(state.position!);
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    addressController.dispose();
    searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _setMarker(LatLng position) {
    setState(() {
      _markers.clear();

      _markers.add(
        Marker(
          markerId: const MarkerId("selected_location"),
          position: position,
        ),
      );
    });
  }

  Future<void> _searchLocation(String value) async {
    try {
      if (value.trim().isEmpty) return;

      List<Location> locations =
      await locationFromAddress(value);

      if (locations.isEmpty) {
        Utils.showToast("Location not found");
        return;
      }

      final lat = locations.first.latitude;
      final lng = locations.first.longitude;

      LatLng newPosition = LatLng(lat, lng);

      ref
          .read(locationProvider.notifier)
          .updatePosition(newPosition);

      _setMarker(newPosition);

      await _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newPosition,
            zoom: 16,
          ),
        ),
      );
    } catch (e) {
      debugPrint("Search Error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location not found"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationProvider);

    final profileState = ref.watch(profileProvider);

    final addresses =
        profileState.getProfileData?.data?.addressResponses;

    final address =
    (addresses != null && addresses.isNotEmpty)
        ? addresses.first
        : null;

    if (addresses != null &&
        addresses.isNotEmpty &&
        _initialAddress.isEmpty) {
      _initialAddress =
          addresses.first.areaStreetCityBlockDetails
              ?.trim() ??
              '';
    }

      addressController.text = state.address;

    final theme = Theme.of(context);

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: (widget.profile == "")
              ? "Restaurant Address"
              : "Edit Restaurant Address",
          leading: IconButton(
            onPressed: () {
              setState(() => _showMap = false);

              NavUtil.popScreen(context, 2);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ).getAppBar(context),

        body: state.loading || state.position == null
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          child: Column(
            children: [
              _searchBar(context),

              SizedBox(
                height:
                MediaQuery.sizeOf(context).height *
                    0.4,

                child: _showMap
                    ? GoogleMap(
                  zoomGesturesEnabled: true,
                  mapType: MapType.normal,

                  initialCameraPosition:
                  CameraPosition(
                    target: state.position!,
                    zoom: 18,
                  ),

                  markers: _markers,

                  myLocationEnabled: true,

                  myLocationButtonEnabled:
                  true,

                  zoomControlsEnabled: false,

                  buildingsEnabled: true,

                  trafficEnabled: true,

                  indoorViewEnabled: true,

                  compassEnabled: true,

                  onMapCreated: (controller) {
                    _mapController =
                        controller;

                    _setMarker(
                      state.position!,
                    );

                    controller
                        .animateCamera(
                      CameraUpdate
                          .newCameraPosition(
                        CameraPosition(
                          target:
                          state.position!,
                          zoom: 18,
                        ),
                      ),
                    );
                  },

                  onTap: (latLng) async {
                    ref
                        .read(
                      locationProvider
                          .notifier,
                    )
                        .updatePosition(
                      latLng,
                    );

                    _setMarker(latLng);

                    await _mapController
                        ?.animateCamera(
                      CameraUpdate
                          .newLatLng(
                        latLng,
                      ),
                    );
                  },
                )
                    : const SizedBox(),
              ),

              Padding(
                padding: EdgeInsets.all(
                  Constant.CONTAINER_SIZE_16,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height:
                      Constant.CONTAINER_SIZE_16,
                    ),

                    Form(
                      key: _formKey,

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,

                        children: [
                          CustomTheme.textField(
                            isSearch: false,
                            addressController,
                            "Enter Restaurant address",
                            maxLine: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(
                  Constant.CONTAINER_SIZE_16,
                ),
                child: SizedBox(
                  width: double.infinity,

                  child: SubmitButton(
                    onRightTap: () async {
                      if (widget.profile == "") {
                        Navigator.pop(
                          context,
                          {
                            "lat": state
                                .position!.latitude,

                            "lng": state
                                .position!.longitude,

                            "address":
                            addressController
                                .text
                                .isNotEmpty
                                ? addressController
                                .text
                                : "",
                          },
                        );
                      } else if (widget.profile ==
                          "profile") {
                        final typedAddress =
                        addressController.text
                            .trim();

                        final mapAddress =
                        state.address.trim();

                        if (address == null) {
                          Utils.showToast(
                            'Address data not available',
                          );

                          return;
                        }

                        final finalAddress =
                        typedAddress
                            .isNotEmpty
                            ? typedAddress
                            : mapAddress;

                        if (finalAddress
                            .isEmpty) {
                          Utils.showToast(
                            'Please enter or select address',
                          );

                          return;
                        }

                        if (finalAddress ==
                            _initialAddress) {
                          Utils.showToast(
                            'No changes detected',
                          );

                          return;
                        }

                        Navigator.pop(
                          context,
                          {
                            "lat": state
                                .position!.latitude,

                            "lng": state
                                .position!.longitude,

                            "address":
                            addressController
                                .text
                                .isNotEmpty
                                ? addressController
                                .text
                                : "",
                          },
                        );
                      }
                    },

                    rightText: Strings.CONFIRM,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(
        Constant.CONTAINER_SIZE_16,
      ),

      child: Material(
        elevation: 0,

        color: theme.scaffoldBackgroundColor,

        borderRadius: BorderRadius.circular(
          Constant.CONTAINER_SIZE_10,
        ),

        child: TextField(
          controller: searchController,

          style: const TextStyle(
            color: Colors.white,
          ),

          cursorColor: Colors.white,

          onChanged: (value) {
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }

            _debounce = Timer(
              const Duration(milliseconds: 800),
                  () {
                _searchLocation(value);
              },
            );
          },

          decoration: InputDecoration(
            hintText:
            'Search for area, street name...',

            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.7),
            ),

            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),

            filled: true,

            fillColor:
            theme.scaffoldBackgroundColor,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Constant.CONTAINER_SIZE_12,
              ),

              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Constant.CONTAINER_SIZE_12,
              ),

              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),

            contentPadding:
            EdgeInsets.symmetric(
              vertical:
              Constant.CONTAINER_SIZE_14,
            ),
          ),
        ),
      ),
    );
  }
}