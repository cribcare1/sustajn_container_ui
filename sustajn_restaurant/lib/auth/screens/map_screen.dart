import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/utils/theme_utils.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../utils/nav_utils.dart';
import '../auth_state/location_state.dart';

class MapScreen extends ConsumerStatefulWidget {
  final String? profile;

  const MapScreen({super.key, this.profile = ""});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final TextEditingController addressController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  final Set<Marker> _markers = {};

  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(locationProvider.notifier).initialize();

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

    ref.read(locationProvider.notifier).mapController?.dispose();

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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationProvider);

    if (state.address.isNotEmpty) {
      addressController.text = state.address;
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: (widget.profile == "")
            ? "Restaurant Address"
            : "Edit Restaurant Address",
        leading: IconButton(
          onPressed: () {
             NavUtil.popScreen(context, 1);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ).getAppBar(context),

      body: state.loading && state.position == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _searchBar(context),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: state.position ?? const LatLng(20.5937, 78.9629),

                      zoom: 16,
                    ),

                    markers: _markers,

                    myLocationEnabled: true,

                    myLocationButtonEnabled: true,

                    zoomControlsEnabled: false,

                    onMapCreated: (controller) {
                      ref
                          .read(locationProvider.notifier)
                          .setMapController(controller);

                      if (state.position != null) {
                        _setMarker(state.position!);
                      }
                    },

                    onTap: (LatLng latLng) async {
                      await ref
                          .read(locationProvider.notifier)
                          .onMapTap(latLng);

                      _setMarker(latLng);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),

                  child: Column(
                    children: [
                      CustomTheme.textField(
                        addressController,
                        "Enter address",
                        maxLine: 3,
                        isSearch: false,
                      ),

                      SizedBox(height: Constant.CONTAINER_SIZE_16),

                      SizedBox(
                        width: double.infinity,

                        child: SubmitButton(
                          onRightTap: () {
                            Navigator.pop(context, {
                              "lat": state.position?.latitude,

                              "lng": state.position?.longitude,

                              "address": addressController.text,
                            });
                          },

                          rightText: Strings.CONFIRM,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _searchBar(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),

      child: Material(
        elevation: 0,

        color: theme.scaffoldBackgroundColor,

        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),

        child: TextField(
          controller: searchController,

          style: const TextStyle(color: Colors.white),

          cursorColor: Colors.white,

          onChanged: (value) {
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }

            _debounce = Timer(const Duration(milliseconds: 700), () {
              ref.read(locationProvider.notifier).searchAddress(value);
            });
          },

          decoration: InputDecoration(
            hintText: 'Search for area, street name...',

            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),

            prefixIcon: const Icon(Icons.search, color: Colors.white),

            filled: true,

            fillColor: theme.scaffoldBackgroundColor,

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),

              borderSide: const BorderSide(color: Colors.white),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),

              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),

            contentPadding: EdgeInsets.symmetric(
              vertical: Constant.CONTAINER_SIZE_14,
            ),
          ),
        ),
      ),
    );
  }
}
