import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/number_constants.dart';
import '../../notifier/location_state.dart';
import '../../provider/signup_provider.dart';
import '../../utils/nav_utils.dart';
import '../../utils/theme_utils.dart';
import '../payment_type/payment_screen.dart';

class HomeAddress extends ConsumerStatefulWidget {
  const HomeAddress({super.key});

  @override
  ConsumerState<HomeAddress> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<HomeAddress> {
  final Completer<GoogleMapController> _controller = Completer();

  int selectedSaveAs = 0;
  final searchController = TextEditingController();
  final flatController = TextEditingController();
  final streetController = TextEditingController();
  final saveAsController = TextEditingController();


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
            ? const Center(
          child: CircularProgressIndicator(color: Constant.gold),
        )
            : Column(
          children: [
            /// 🔍 SEARCH BAR (FIXED BELOW APPBAR)
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTheme.searchField(
                searchController,
                'Search by restaurant name',
              ),
            ),

            /// 🗺 MAP + BOTTOM SHEET
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

                  /// 📍 CENTER PIN
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
    );
  }

  Widget _bottomContent(LocationState state, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// USE CURRENT LOCATION
        GestureDetector(
          onTap: () {
            ref.read(signUpNotifier).setAddress(
              address: state.address,
              postalCode: state.postalCode,
              latitude: state.position!.latitude,
              longitude: state.position!.longitude,
            );
            NavUtil.navigateWithReplacement(PaymentTypeScreen());
          },
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

        /// ADDRESS
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

        /// SAVE AS WITH ICONS
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

        /// CONFIRM BUTTON
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
              final saveAs = selectedSaveAs == 0
                  ? "Home"
                  : selectedSaveAs == 1
                  ? "Work"
                  : saveAsController.text;

              final manualAddress =
                  "$saveAs, ${flatController.text}, ${streetController.text}";

              ref.read(signUpNotifier).setAddress(
                address: manualAddress,
                postalCode: state.postalCode,
                latitude: state.position!.latitude,
                longitude: state.position!.longitude,
              );

              NavUtil.navigateWithReplacement(PaymentTypeScreen());
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


}
