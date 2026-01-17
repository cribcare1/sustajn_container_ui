import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_customer/provider/search_res_provider.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_profile_model.dart';
import '../../models/profile_model.dart';
import '../../network_provider/network_provider.dart';
import '../../notifier/location_state.dart';
import '../../provider/signup_provider.dart';
import '../../utils/nav_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utils.dart';
import '../payment_type/payment_screen.dart';

enum AddressFlow {
  signup,
  profile,
}

class HomeAddress extends ConsumerStatefulWidget {
  final AddressFlow flow;
  final AddressResponses? existingAddress;
  const HomeAddress({super.key, required this.flow, this.existingAddress});

  @override
  ConsumerState<HomeAddress> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<HomeAddress> {
  final Completer<GoogleMapController> _mapController = Completer();

  int selectedSaveAs = 0;
  final searchController = TextEditingController();
  final flatController = TextEditingController();
  final streetController = TextEditingController();
  final saveAsController = TextEditingController();
  bool _isSearching = false;
  Timer? _searchDebounce;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(locationProvider.notifier).initialize();

      if (widget.existingAddress != null) {
        final addr = widget.existingAddress!;

        if (addr.addressType == "HOME") {
          selectedSaveAs = 0;
        } else if (addr.addressType == "WORK") {
          selectedSaveAs = 1;
        } else {
          selectedSaveAs = 2;
          saveAsController.text = addr.addressType ?? "";
        }

        flatController.text = addr.flatDoorHouseDetails ?? "";
        streetController.text = addr.areaStreetCityBlockDetails ?? "";

      }

      setState(() {});
    });
  }



  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) return;

    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _onSearch(query);
    });
  }

  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) return;

    try {
      _isSearching = true;

      final results = await locationFromAddress(query);
      if (results.isEmpty) return;

      final latLng = LatLng(
        results.first.latitude,
        results.first.longitude,
      );

      final controller = await _mapController.future;

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 17),
        ),
      );

      ref.read(locationProvider.notifier).updatePosition(latLng);
    } catch (e) {
      debugPrint("Search failed: $e");
    } finally {
      Future.delayed(const Duration(milliseconds: 400), () {
        _isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    searchController.dispose();
    flatController.dispose();
    streetController.dispose();
    saveAsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationProvider);
    final theme = Theme.of(context);
    final addressState = ref.watch(searchResProvider);


    return SafeArea(
      top: false,
      bottom: true,
      child: Stack(
        children:[
          Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: "Select Home Address",
            leading: CustomBackButton(),
          ).getAppBar(context),

          body: state.loading || state.position == null
              ? const Center(
            child: CircularProgressIndicator(color: Constant.gold),
          )
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: "Search address / pincode / area",
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: const Color(0xff1b4d3a),
                      prefixIcon:
                      const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                      ),
                      enabledBorder: CustomTheme.roundedBorder(Constant.grey),
                      focusedBorder: CustomTheme.roundedBorder(Constant.grey)
                  ),
                  onChanged: _onSearchChanged,
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
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) {
                        _mapController.complete(controller);
                      },
                      onCameraIdle: () async {
                        if (_isSearching) return;

                        final controller = await _mapController.future;
                        final bounds = await controller.getVisibleRegion();

                        final center = LatLng(
                          (bounds.northeast.latitude +
                              bounds.southwest.latitude) / 2,
                          (bounds.northeast.longitude +
                              bounds.southwest.longitude) / 2,
                        );

                        ref.read(locationProvider.notifier).updatePosition(center);
                      },

                    ),

                    const Center(
                      child: Icon(
                        Icons.location_pin,
                        size: 44,
                        color: Colors.red,
                      ),
                    ),

                    DraggableScrollableSheet(
                      initialChildSize: 0.45,
                      minChildSize: 0.35,
                      maxChildSize: 0.75,
                      builder: (context, scrollController) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xff0f3d2e),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: _bottomContent(state, context),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),


        ),
          if(addressState.isLoading)
            Utils.showProgressBar()
      ]
      ),
    );
  }

  Widget _bottomContent(LocationState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Constant.gold),
              borderRadius: BorderRadius.circular(20),
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
        ),

        const SizedBox(height: 12),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Constant.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white),
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

        const SizedBox(height: 16),

        Row(
          children: [
            _saveAsChip("Home", Icons.home_outlined, 0),
            const SizedBox(width: 8),
            _saveAsChip("Work", Icons.work_outline, 1),
            const SizedBox(width: 8),
            _saveAsChip("Other", Icons.location_on_outlined, 2),
          ],
        ),

        if (selectedSaveAs == 2) ...[
          const SizedBox(height: 12),
          _inputField("Save as", saveAsController),
        ],

        const SizedBox(height: 12),
        _inputField("Flat / Door / House", flatController),
        const SizedBox(height: 12),
        _inputField(
          "Street / Block / City / Postal Code",
          streetController,
          isLarge: true,
        ),


        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffe3b023),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              final String addressType = selectedSaveAs == 0
                  ? "HOME"
                  : selectedSaveAs == 1
                  ? "WORK"
                  : saveAsController.text.trim();

              final String flatDetails = flatController.text.trim();

              final String areaDetails = streetController.text.trim().isEmpty
                  ? state.address
                  : "${streetController.text}, ${state.address}";

              if (widget.flow == AddressFlow.signup) {
                ref.read(signUpNotifier).setAddress(
                  addressType: addressType,
                  flatDoorHouseDetails: flatDetails,
                  areaStreetCityBlockDetails: areaDetails,
                  poBoxOrPostalCode: state.postalCode,
                  latitude: state.position!.latitude,
                  longitude: state.position!.longitude,
                );

                NavUtil.navigateWithReplacement(
                  PaymentTypeScreen(flow: PaymentFlow.signup),
                );
                return;
              }

              if (widget.existingAddress != null) {
                final body = {
                  "addressId": widget.existingAddress!.id,
                  "addressType": addressType,
                  "flatDoorHouseDetails": flatDetails,
                  "areaStreetCityBlockDetails": areaDetails,
                  "poBoxOrPostalCode": state.postalCode,
                };

                _editAddressNetwork(body);
              } else {
                final body = {
                  "userId": Utils.userId,
                  "addressType": addressType,
                  "flatDoorHouseDetails": flatDetails,
                  "areaStreetCityBlockDetails": areaDetails,
                  "poBoxOrPostalCode": state.postalCode,
                };

                _addNewAddress(body);
              }
            },



            child: Text(
              "Confirm & Continue",
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _saveAsChip(String text, IconData icon, int index) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 6),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _inputField(
      String hint,
      TextEditingController controller, {
        bool isLarge = false,
      }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      minLines: isLarge ? 2 : 1,
      maxLines: isLarge ? 3 : 1,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),

        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: isLarge ? 20 : 14,
        ),

        enabledBorder: CustomTheme.roundedBorder(Constant.grey),
        focusedBorder: CustomTheme.roundedBorder(Constant.grey),
      ),
    );
  }


  _addNewAddress( Map<String, dynamic> body) async {
  final profileState = ref.read(searchResProvider);
    try {
        await ref.read(networkProvider.notifier).isNetworkAvailable().then((
            isNetworkAvailable,
            ) async {
          try {
            if (isNetworkAvailable) {
              profileState.setLoading(true);
              profileState.setContext(context);
              ref.read(createAddressProvider(body));
            } else {
              profileState.setLoading(false);
              if (!mounted) return;
              showCustomSnackBar(
                context: context,
                message: Strings.NO_INTERNET_CONNECTION,
                color: Colors.red,
              );
            }
          } catch (e) {
            Utils.printLog('Error on button onPressed: $e');
            profileState.setLoading(false);
          }
          if (!mounted) return;
          FocusScope.of(context).unfocus();
        });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      profileState.setLoading(false);
    }
  }

  _editAddressNetwork( Map<String, dynamic> body) async {
    final profileState = ref.read(searchResProvider);
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) async {
        try {
          if (isNetworkAvailable) {
            profileState.setLoading(true);
            profileState.setContext(context);
            ref.read(editAddressProvider(body));
          } else {
            profileState.setLoading(false);
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
          profileState.setLoading(false);
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
      profileState.setLoading(false);
    }
  }

}