import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sustajn_restaurant/auth/auth_state/location_state.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/constants/imports_util.dart';
import 'package:sustajn_restaurant/search_screen/search_restaurant_model.dart';
import 'package:sustajn_restaurant/search_screen/search_restaurant_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/theme_utils.dart';
import '../constants/string_utils.dart';
import '../network_provider/network_provider.dart';
import '../utils/utility.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(searchResProvider).setContext(context);
      await ref.read(locationProvider.notifier).initialize();
      if (!mounted) return;
      if (ref.read(locationProvider).position != null) {
        _getNetworkData(_lastKeyword);
      }
    });
  }

  String _lastKeyword = "re";

  Future<void> _getNetworkData(String keyword) async {
    final searchProvider = ref.read(searchResProvider);
    final state = ref.read(locationProvider);

    if (state.position == null) return;

    final body = {
      "keyword": keyword,
      "lat": state.position!.latitude,
      "lon": state.position!.longitude,
    };

    try {
      searchProvider.setLoading(true);
      final isNetworkAvailable = await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable();

      if (!isNetworkAvailable) {
        showCustomSnackBar(
          context: context,
          message: Strings.NO_INTERNET_CONNECTION,
          color: Colors.red,
        );
        return;
      }

      ref.read(searchRestaurant(body));
    } catch (e) {
      Utils.printLog("API Error: $e");
    }
  }

  Set<Marker> _buildMarkers(List<SearchData> list) {
    return list
        .where((e) => e.latitude != 0 && e.longitude != 0)
        .map(
          (data) => Marker(
        markerId: MarkerId(data.id.toString()),
        position: LatLng(data.latitude, data.longitude),

        onTap: () {
          _showRestaurantPopup(data);
        },
        // TODO
        // infoWindow: InfoWindow(
        //   title: data.name,
        //   snippet: "${data.distanceKm.toStringAsFixed(2)} km",
        // ),
      ),
    )
        .toSet();
  }

  void _showRestaurantPopup(SearchData data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            data.name,
            style: Theme.of(
              context,
            ).textTheme.titleLarge!.copyWith(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  data.address,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(color: Colors.grey,fontSize: 12),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${data.distanceKm.toStringAsFixed(2)} km away",
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Close",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: Colors.orangeAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                _openMap(
                  data.latitude,
                  data.longitude,
                  data.name,
                );
              },
              child: Text(
                "View Map",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Future<void> _openMap(double lat, double lng, String name) async {
    final Uri url = Platform.isIOS
        ? Uri.parse(
      'https://maps.apple.com/?q=$name&ll=$lat,$lng',
    )
        : Uri.parse(
      'geo:$lat,$lng?q=$lat,$lng($name)',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      final fallbackUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );

      await launchUrl(
        fallbackUrl,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(locationProvider);
    final searchProvider = ref.watch(searchResProvider);
    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(
          title: "Search Restaurant",
          leading: CustomBackButton(),
        ).getAppBar(context),
        body: state.position == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomTheme.searchField(
                      searchController,
                      'Search by restaurant name',
                      onChanged: (value) {
                        if (value.isEmpty) {
                          _getNetworkData(_lastKeyword);
                        } else if (value.length >= 3) {
                          _lastKeyword = value;
                          _getNetworkData(value.toLowerCase());
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: GoogleMap(
                      key: const ValueKey("google_map"),

                      initialCameraPosition: CameraPosition(
                        target: state.position!,
                        zoom: 14,
                      ),

                      mapType: MapType.normal,

                      markers: _buildMarkers(searchProvider.resList),

                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,

                      zoomControlsEnabled: false,
                      compassEnabled: true,

                      buildingsEnabled: false,
                      trafficEnabled: false,
                      indoorViewEnabled: false,

                      onMapCreated: (GoogleMapController controller) {
                        if (!_controller.isCompleted) {
                          _controller.complete(controller);
                        }
                      },

                      onTap: (LatLng latLng) async {
                        searchController.clear();

                        ref
                            .read(locationProvider.notifier)
                            .updatePosition(latLng);

                        await _getNetworkData(_lastKeyword);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme!.secondaryHeaderColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: Constant.CONTAINER_SIZE_12,
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
                          searchController.clear();
                          await ref
                              .read(locationProvider.notifier)
                              .initialize();
                          final pos = ref.read(locationProvider).position;
                          if (pos == null) return;
                          final controller = await _controller.future;
                          controller.animateCamera(
                            CameraUpdate.newLatLngZoom(pos, 17),
                          );
                          _getNetworkData(_lastKeyword);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: (searchProvider.isLoading)
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : (searchProvider.resList.isEmpty)
                        ? const Center(
                      child: Text("No Data"),
                    )
                        : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Nearby Restaurants',
                              style: theme!.textTheme.titleMedium!.copyWith(
                                color: Constant.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: Constant.SIZE_08),
                        Expanded(
                          child: ListView.separated(
                            keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.manual,
                            padding: EdgeInsets.symmetric(
                              horizontal: Constant.CONTAINER_SIZE_16,
                            ),
                            separatorBuilder: (context, index) =>
                            const Divider(color: Colors.grey),
                            itemCount: searchProvider.resList.length,
                            itemBuilder: (context, index) {
                              final data =
                              searchProvider.resList[index];

                              return RestaurantTile(
                                name: data.name,
                                distance:
                                '${data.distanceKm.toStringAsFixed(2)} \nkm',
                                address: data.address,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: theme?.secondaryHeaderColor),
              Text(
                distance,
                textAlign: TextAlign.center,
                style: theme?.textTheme.titleSmall?.copyWith(
                  color: theme.secondaryHeaderColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme?.textTheme.titleMedium?.copyWith(
                  color: Constant.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                overflow: TextOverflow.ellipsis,
                style: theme?.textTheme.titleSmall?.copyWith(
                  color: Constant.white,
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
