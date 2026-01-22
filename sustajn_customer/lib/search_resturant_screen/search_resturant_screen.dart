import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/theme_utils.dart';
import '../common_widgets/custom_app_bar.dart';
import '../common_widgets/custom_back_button.dart';
import '../constants/imports_util.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../models/resturant_address_model.dart';
import '../network_provider/network_provider.dart';
import '../notifier/location_state.dart';
import '../provider/search_res_provider.dart';
import '../utils/utils.dart';

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
      ref.read(locationProvider.notifier).initialize().then((value) {
        ref.read(searchResProvider).setContext(context);
        final location = ref.read(locationProvider).position;
        if (location != null) {
          _getNetworkData(_lastKeyword);
        }
      });
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

      ref.read(searchRes(body));
    } catch (e) {
      Utils.printLog("API Error: $e");
    }
  }

  Set<Marker> _buildMarkers(List<SearchData> list) {
    return list.map((data) {
      return Marker(
        draggable: true,
        flat: true,
        markerId: MarkerId(data.id.toString()),
        position: LatLng(data.latitude, data.longitude),
        infoWindow: InfoWindow(
          title: data.name,
          snippet: "${data.distanceKm.toStringAsFixed(2)} km",
          onTap: () {
            _showRestaurantPopup(data);
          },
        ),
      );
    }).toSet();
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
              Text(
                data.address,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: Colors.white),
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
          ],
        );
      },
    );
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
            ? Center(
          child: CircularProgressIndicator(color: Constant.gold),
        )
            : Column(
          children: [
            /// Search Bar
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

            /// Full screen map
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: state.position!,
                  zoom: 17,
                ),
                markers: _buildMarkers(searchProvider.resList),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
                compassEnabled: true,
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                onTap: (latLng) {
                  searchController.clear();
                  ref.read(locationProvider.notifier).updatePosition(latLng);
                  _getNetworkData(_lastKeyword);
                },
                onCameraIdle: () async {
                  final controller = await _controller.future;
                  final bounds = await controller.getVisibleRegion();
                  final center = LatLng(
                    (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
                    (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
                  );

                  final oldPos = ref.read(locationProvider).position;
                  if (oldPos == null ||
                      oldPos.latitude != center.latitude ||
                      oldPos.longitude != center.longitude) {
                    ref.read(locationProvider.notifier).updatePosition(center);
                    _getNetworkData(_lastKeyword);
                  }
                },
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
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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

          Expanded(
            flex: 1,
            child: const Icon(Icons.chevron_right, color: Constant.white),
          ),
        ],
      ),
    );
  }
}
