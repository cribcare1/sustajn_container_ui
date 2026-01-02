import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_restaurant/auth/auth_state/location_state.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';

import '../../utils/theme_utils.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFF0E3B2E),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0E3B2E),
        elevation: 0,
        centerTitle: true,
        leading: CustomBackButton(),
        title: Text(
          'Search Restaurant',
          style: theme!.textTheme.titleMedium!.copyWith(color: Constant.white),
        ),
      ),
      body: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: CustomTheme.searchField(
                            searchController,
                            'Search by restaurant name',
                          ),
                        ),

                        /// Map
                        Container(
                          height: 260,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
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
                                  final controller =
                                  await _controller.future;
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
                                  size: 42,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Use current location
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(16),
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: theme!.secondaryHeaderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(30),
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
                            onPressed: () {},
                          ),
                        ),

                        /// Restaurant list
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    'Nearby Restaurants',
                                    style: theme!.textTheme.titleLarge!
                                        .copyWith(
                                      color: Constant.white,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  RestaurantTile(
                                    name: 'Dragonfly Dubai',
                                    distance: '1km',
                                    address:
                                    'The Lana Promenade...',
                                  ),
                                  RestaurantTile(
                                    name: 'Firelake Grill House',
                                    distance: '5km',
                                    address:
                                    'Radisson Blu...',
                                  ),
                                  RestaurantTile(
                                    name: 'Hakoora Dubai',
                                    distance: '9km',
                                    address:
                                    'Yansoon 9...',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
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
              Icon(Icons.location_on, color: theme?.secondaryHeaderColor),
              Text(
                distance,
                style: theme?.textTheme.titleSmall?.copyWith(
                  color: theme.secondaryHeaderColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: theme?.textTheme.titleMedium?.copyWith(
                        color: Constant.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: theme?.textTheme.titleSmall?.copyWith(
                    color: Constant.white,
                  ),
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
