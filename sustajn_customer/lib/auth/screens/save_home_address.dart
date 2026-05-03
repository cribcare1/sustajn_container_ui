import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_customer/provider/search_res_provider.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_profile_model.dart';
import '../../network_provider/network_provider.dart';
import '../../notifier/location_state.dart';
import '../../provider/profile_provider.dart';
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
  final _formKey = GlobalKey<FormState>();

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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          children:[
            Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title:  Utils.getAppBarTitle(
                flow: widget.flow,
                existingAddress: widget.existingAddress,
              ),
              leading: CustomBackButton(
                onBack: _onBackPressed,
              ),
            ).getAppBar(context),

            body:
           Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: searchController,
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: Strings.SEARCH_ADDRESS,
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
                      if( state.position != null)GoogleMap(
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
                              child: Form(
                                  key: _formKey,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  child: _bottomContent(state, context, addressState)),
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
            // if(addressState.isLoading)
            //   Utils.showProgressBar()
        ]
        ),
      ),
    );
  }



  Widget _bottomContent(LocationState state, BuildContext context, var addressState) {
    streetController.text = state.address;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // GestureDetector(
        //   child: Container(
        //     width: double.infinity,
        //     padding: const EdgeInsets.symmetric(vertical: 12),
        //     decoration: BoxDecoration(
        //       border: Border.all(color: Constant.gold),
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     child: const Center(
        //       child: Text(
        //        Strings.USE_CURRENT_LOCATION,
        //         style: TextStyle(
        //           color: Constant.gold,
        //           fontWeight: FontWeight.w600,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        //
        // const SizedBox(height: 12),

        // Container(
        //   padding: const EdgeInsets.all(14),
        //   decoration: BoxDecoration(
        //     color: Constant.grey.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Row(
        //     children: [
        //       const Icon(Icons.location_on, color: Colors.white),
        //       const SizedBox(width: 10),
        //       Expanded(
        //         child: Text(
        //           state.address,
        //           style: const TextStyle(color: Colors.white),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        //
        // const SizedBox(height: 16),

        Row(
          children: [
            _saveAsChip(Strings.HOME_TXT, Icons.home_outlined, 0),
            const SizedBox(width: 8),
            _saveAsChip(Strings.WORK_TXT, Icons.work_outline, 1),
            const SizedBox(width: 8),
            _saveAsChip(Strings.OTHER_TXT, Icons.location_on_outlined, 2),
          ],
        ),

        if (selectedSaveAs == 2) ...[
          const SizedBox(height: 12),
          _inputField(Strings.SAVE_AS, saveAsController),
        ],

        const SizedBox(height: 12),
        _inputField(Strings.FLAT_FLOOR_TXT, flatController,
        isRequired: true),

        const SizedBox(height: 12),

        _inputField(
          Strings.STREET_BLOCK_TXT,
          streetController,
          isLarge: true,
          isRequired: false
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
            onPressed: addressState.isLoading
                ? null
                : () {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              final String addressType = selectedSaveAs == 0
                  ? Strings.HOME
                  : selectedSaveAs == 1
                  ? Strings.WORK
                  : saveAsController.text.trim();

              final String flatDetails = flatController.text.trim();

              final String areaDetails =
              streetController.text.trim().isEmpty
                  ? state.address
                  : "${streetController.text}";

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
            child: addressState.isLoading
                ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Constant.gold,
              ),
            )
                : Text(
              Strings.CONFIRM_CONTINUE,
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

  Future<bool> _onBackPressed() async {

    if (widget.flow == AddressFlow.profile) {
      return true;
    }
    final result = await displayDialog(
      context,
      Icons.warning_amber,
      Strings.GO_BACK,
      Strings.VERIFIED_EMAIL,
      Strings.STAY_ON_THIS_PAGE,
    );

    if (result) {
      Navigator.pop(context);
    }

    return false;
  }

  Future<bool> displayDialog(
      BuildContext context,
      IconData icon,
      String title,
      String subTitle,
      String stayButtonText,
      ) async {
    final theme = Theme.of(context);

    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: Constant.PADDING_HEIGHT_10,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    Constant.CONTAINER_SIZE_12,
                  ),
                  border: Border.all(color: Constant.grey.withOpacity(0.1)),
                  color: Constant.white.withOpacity(0.1),
                  shape: BoxShape.rectangle,
                ),
                child: Icon(
                  icon,
                  size: Constant.CONTAINER_SIZE_40,
                  color: Constant.gold,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Constant.SIZE_05),
              Text(
                subTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_12),

              Row(
                children: [
                  // GO BACK
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC8B531)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        Strings.GO_BACKS,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Constant.gold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: Constant.CONTAINER_SIZE_12),

                  // STAY
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                      ),
                      child: Text(
                        maxLines: 1,
                        stayButtonText,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ) ??
        false;
  }


  Widget _inputField(
      String hint,
      TextEditingController controller, {
        bool isLarge = false,
        bool isRequired = true,
      }) {

    return TextFormField(
      controller: controller,
      cursorColor: Colors.white70,
      style: const TextStyle(color: Colors.white),
      minLines: isLarge ? 2 : 1,
      maxLines: isLarge ? 3 : 1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!isRequired) return null;
        if (value == null || value.trim().isEmpty) {
          return "Please fill this field";
        }
        return null;
      },
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
              await ref.read(createAddressProvider(body).future);

              ref.read(profileProvider).clearProfileList();
              await ref.read(
                getProfileProvider('${NetworkUrls.GET_PROFILE}${Utils.userId}').future,
              );
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
            await ref.read(editAddressProvider(body).future);
            ref.read(profileProvider).clearProfileList();
            await ref.read(
              getProfileProvider('${NetworkUrls.GET_PROFILE}${Utils.userId}').future,
            );
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