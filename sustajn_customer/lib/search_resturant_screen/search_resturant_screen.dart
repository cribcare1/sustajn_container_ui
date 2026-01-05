import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/theme_utils.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/imports_util.dart';
import '../constants/number_constants.dart';
import '../notifier/location_state.dart';

class SearchRestaurantScreen extends ConsumerStatefulWidget {
  const SearchRestaurantScreen({super.key});

  @override
  ConsumerState<SearchRestaurantScreen> createState() =>
      _SearchRestaurantScreenState();
}

class _SearchRestaurantScreenState
    extends ConsumerState<SearchRestaurantScreen> {
  final theme = CustomTheme.getTheme(true);
  final Completer<GoogleMapController> _controller = Completer();

  final searchController = TextEditingController();
  Set<Marker> _markers = {};

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

    // 🔴 Loading / GPS off state
    if (state.position == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0E3B2E),
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E3B2E),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3B2E),
        elevation: 0,
        centerTitle: true,
        leading: const CustomBackButton(),
        title: Text(
          'Search Restaurant',
          style: theme!.textTheme.titleMedium!.copyWith(color: Constant.white),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// 🔍 Search Field
            Padding(
              padding: const EdgeInsets.all(16),
              child: CustomTheme.searchField(
                searchController,
                'Search by restaurant name',
              ),
            ),

            SizedBox(
              height: 260,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: state.position!,
                  zoom: 15,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                compassEnabled: true,

                onMapCreated: (controller) {
                  if (!_controller.isCompleted) {
                    _controller.complete(controller);
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme!.secondaryHeaderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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
                onPressed: () {
                  ref.read(locationProvider.notifier).initialize();
                },
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Nearby Restaurants',
                      style: theme!.textTheme.titleLarge!
                          .copyWith(color: Constant.white),
                    ),
                    const SizedBox(height: 12),

                    const RestaurantTile(
                      name: 'Dragonfly Dubai',
                      distance: '1km',
                      address:
                      'The Lana Promenade, Dorchester Collection, Marasi...',
                    ),
                    const RestaurantTile(
                      name: 'Firelake Grill House',
                      distance: '5km',
                      address:
                      'Radisson Blu Hotel Dubai Waterfront, Marasi Drive...',
                    ),
                    const RestaurantTile(
                      name: 'Hakoora Dubai',
                      distance: '9km',
                      address: 'Yansoon 9, Downtown Dubai, Dubai',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantTile extends StatelessWidget {
  final String name;
  final String distance;
  final String address;

  const RestaurantTile({
    super.key,
    required this.name,
    required this.distance,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final theme = CustomTheme.getTheme(true);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Column(
            children: [
              Icon(Icons.location_on,
                  color: theme?.secondaryHeaderColor),
              Text(
                distance,
                style: theme?.textTheme.titleSmall?.copyWith(
                  color: theme?.secondaryHeaderColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme?.textTheme.titleMedium
                      ?.copyWith(color: Constant.white),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: theme?.textTheme.titleSmall
                      ?.copyWith(color: Constant.white),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Constant.white),
        ],
      ),
    );
  }
}
