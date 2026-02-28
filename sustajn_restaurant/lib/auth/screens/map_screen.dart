import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';
import 'package:sustajn_restaurant/constants/string_utils.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../../network_provider/network_provider.dart';
import '../../provider/profile_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../auth_state/location_state.dart';

class MapScreen extends ConsumerStatefulWidget {
  final String? profile;

  const MapScreen({super.key, this.profile = ""});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final _formKey = GlobalKey<FormState>();
  final addressController = TextEditingController();
  bool _showMap = true;
  String _initialAddress = "";

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
    var profileState = ref.watch(profileProvider);
    final addresses = profileState.getProfileData?.data?.addressResponses;
    final address = (addresses != null && addresses.isNotEmpty)
        ? addresses.first
        : null;
    if (addresses != null && addresses.isNotEmpty && _initialAddress.isEmpty) {
      _initialAddress =
          addresses.first.areaStreetCityBlockDetails?.trim() ?? '';

      addressController.text = _initialAddress;
    }

    final theme = Theme.of(context);
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Edit Restaurant Address",
          leading: IconButton(
            onPressed: () {
              setState(() => _showMap = false);
              NavUtil.popScreen(context, 2);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
        ).getAppBar(context),
        body: state.loading || state.position == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _searchBar(context),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      child: Stack(
                        children: [
                          if (_showMap)
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: state.position!,
                                zoom: 17,
                              ),
                              markers: state.position == null
                                  ? {}
                                  : {
                                      Marker(
                                        markerId: const MarkerId(
                                          'selected_location',
                                        ),
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
                                final bounds = await controller
                                    .getVisibleRegion();

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
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: theme.secondaryHeaderColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Constant.CONTAINER_SIZE_30,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: Constant.CONTAINER_SIZE_24,
                                  vertical: Constant.CONTAINER_SIZE_14,
                                ),
                              ),
                              icon: Icon(
                                Icons.my_location,
                                color: theme.secondaryHeaderColor,
                              ),
                              label: Text(
                                'Use Current Location',
                                style: TextStyle(
                                  color: theme.secondaryHeaderColor,
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
                            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_14),
                            decoration: BoxDecoration(
                              color: Color(0xff225343),
                              borderRadius: BorderRadius.circular(
                                Constant.CONTAINER_SIZE_12,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(Constant.SIZE_08),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(
                                      Constant.SIZE_08,
                                    ),
                                  ),
                                  child: Icon(Icons.location_on_outlined),
                                ),
                                SizedBox(width: Constant.CONTAINER_SIZE_10),
                                Expanded(
                                  child: Text(
                                    state.address,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_16),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomTheme.textField(
                                  isSearch: false,
                                  addressController,
                                  "Enter Restaurant address",
                                  maxLine: 3,
                                ),

                                ValueListenableBuilder<TextEditingValue>(
                                  valueListenable: addressController,
                                  builder: (context, value, _) {
                                    final length = value.text.length;
                                    return Text(
                                      "$length/100",
                                      style: TextStyle(
                                        fontSize: Constant.CONTAINER_SIZE_12,
                                        fontWeight: FontWeight.bold,
                                        color: length >= 100
                                            ? Colors.red
                                            : Colors.grey.shade400,
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

                    // CONFIRM
                    Padding(
                      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                      child: SizedBox(
                        width: double.infinity,
                        child: SubmitButton(
                          onRightTap: () async {
                            final typedAddress = addressController.text.trim();
                            final mapAddress = state.address.trim();

                            if (address == null) {
                              Utils.showToast('Address data not available');
                              return;
                            }

                            final finalAddress = typedAddress.isNotEmpty
                                ? typedAddress
                                : mapAddress;

                            if (finalAddress.isEmpty) {
                              Utils.showToast('Please enter or select address');
                              return;
                            }

                            if (finalAddress == _initialAddress) {
                              Utils.showToast('No changes detected');
                              return;
                            }

                            await _editAddressNetworkCall(
                              address.id?.toString() ?? "0",
                              address.addressType ?? "",
                              address.flatDoorHouseDetails ?? "",
                              finalAddress,
                              address.poBoxOrPostalCode ?? "",
                            );
                            NavUtil.popScreen(context, 3);
                          },

                          //todo needed later
                          // Navigator.pop(context, {
                          //   "lat": state.position!.latitude,
                          //   "lng": state.position!.longitude,
                          //   "address":
                          //       "${addressController.text.isNotEmpty ? "${addressController.text}," : ""} ${state.address}",
                          // });
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
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      child: Material(
        elevation: 0,
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'Search for area, street name...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
              borderSide: const BorderSide(color: Colors.white, width: 1),
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

  Map<String, dynamic> getJsonData(
    String addressId,
    String addType,
    String houseDtls,
    String cityDtls,
    String pin,
  ) {
    final data = {
      "addressId": addressId,
      "addressType": addType,
      "flatDoorHouseDetails": houseDtls,
      "areaStreetCityBlockDetails": cityDtls,
      "poBoxOrPostalCode": pin,
    };
    return data;
  }

  _editAddressNetworkCall(
    String addressId,
    String addType,
    String houseDtls,
    String cityDtls,
    String pin,
  ) async {
    Utils.printLog('Update Address Network call');

    final isNetworkAvailable = await ref
        .read(networkProvider.notifier)
        .isNetworkAvailable();

    if (!isNetworkAvailable) {
      Utils.showToast(Strings.NO_INTERNET_CONNECTION);
      return;
    }

    final jsonData = getJsonData(addressId, addType, houseDtls, cityDtls, pin);
    ref.read(addressUpdateProvider(jsonData));
  }
}
