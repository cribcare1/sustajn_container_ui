import 'package:container_tracking/common_widgets/card_widget.dart';
import 'package:container_tracking/resutants/screens/resturant_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_provider/network_provider.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../models/model.dart';
import '../models/restaurant_list_model.dart';
import '../restaurant_provider.dart';

class RestaurantListScreen extends ConsumerStatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  ConsumerState<RestaurantListScreen> createState() =>
      _RestaurantListScreenState();
}

class _RestaurantListScreenState extends ConsumerState<RestaurantListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      ref.read(restaurantNotifierProvider).setContext(context);
      _getNetworkData(ref.read(restaurantNotifierProvider));
    });
    super.initState();
  }

  Future<void> _refreshIndicator() async {
    _getNetworkData(ref.read(restaurantNotifierProvider));
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantNotifierProvider);
    final themeData = CustomTheme.getTheme(true);
    return SafeArea(
      top: false,bottom: true,
      child: Scaffold(
        appBar: CustomAppBar(
          title: Strings.RESTURANT_TITLE,
          leading: SizedBox.shrink(),
          action: [IconButton(onPressed: () { showSearch(
            context: context,
            delegate: RestaurantSearchDelegate(
              restaurantList: restaurantState.restaurantList,theme: themeData!
            ),
          );}, icon: Icon(Icons.search))],
        ).getAppBar(context),
        body: restaurantState.isLoading
            ? Center(child: CircularProgressIndicator())
            : restaurantState.error != ""
            ? Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      restaurantState.error,
                      style: themeData!.textTheme.titleMedium,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green
                      ),
                      onPressed: () {
                        _refreshIndicator();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Constant.SIZE_08),
                        child: Text(
                          "Retry",
                          style: themeData.textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // todo this may need in future
                      // Total Count
                      // Text(
                      //   "Total - ${restaurants.length}",
                      //   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //     fontSize: Constant.LABEL_TEXT_SIZE_16,
                      //     color: Colors.grey.shade700,
                      //     fontWeight: FontWeight.bold
                      //   ),
                      // ),
                      // SizedBox(height: Constant.CONTAINER_SIZE_16),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => _refreshIndicator(),
                          child: restaurantState.restaurantList.isEmpty?
                          Center(child: Text("Restaurant List is not available",style: themeData!.textTheme.titleMedium,),):
                          ListView.separated(
                            itemCount: restaurantState.restaurantList.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: Constant.CONTAINER_SIZE_10),
                            itemBuilder: (context, index) {
                              return RestaurantCard(restaurant: restaurantState.restaurantList[index],onTap: (){Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RestaurantDetailsScreen(restaurant: restaurantState.restaurantList[index]),
                                ),
                              );},);

                                // _buildRestaurantCard(restaurantState.restaurantList[index]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _getNetworkData(var containerState) async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) async {
        try {
          if (isNetworkAvailable) {
            ref.read(fetchRestaurantProvider(true));
          } else {
            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on button onPressed: $e');
        }
        if (!mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Login button onPressed: $e');
    }
  }
}
class RestaurantSearchDelegate extends SearchDelegate {
  final List<RestaurantData> restaurantList;
  final ThemeData theme;

  RestaurantSearchDelegate({
    required this.restaurantList,
    required this.theme,
  });

  @override
  String? get searchFieldLabel => 'Search restaurant';
  @override
  TextStyle? get searchFieldStyle =>
      const TextStyle(color: Colors.white);
  @override
  InputDecorationTheme? get searchFieldDecorationTheme =>
      InputDecorationTheme(
        filled: true,
        fillColor: theme.primaryColor,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white70),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 0,
        ),
      );
  @override
  ThemeData appBarTheme(BuildContext context) {
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: searchFieldDecorationTheme,
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(color: Colors.white),
      ),
    );
  }
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.white),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => close(context, null),
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    final results = _filteredList();

    return SafeArea(
      bottom: true,
      child: results.isEmpty
          ? _emptyState(context)
          : _buildRestaurantList(results),
    );
  }
  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = _filteredList();

    if (suggestions.isEmpty && query.isNotEmpty) {
      return _emptyState(context);
    }

    return _buildRestaurantList(suggestions);
  }
  List<RestaurantData> _filteredList() {
    return restaurantList.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
          restaurant.address.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
  Widget _buildRestaurantList(List<RestaurantData> list) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      separatorBuilder: (_, __) =>
          SizedBox(height: Constant.CONTAINER_SIZE_10),
      itemBuilder: (context, index) {
        return RestaurantCard(
          restaurant: list[index],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    RestaurantDetailsScreen(restaurant: list[index]),
              ),
            );
          },
        );
      },
    );
  }
  Widget _emptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'No restaurants found',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.secondaryHeaderColor,
            ),
            onPressed: () {
              query = '';
              showSuggestions(context);
            },
            icon: const Icon(Icons.clear, color: Colors.white),
            label: Text(
              'Clear search',
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
class RestaurantCard extends StatelessWidget {
  final RestaurantData restaurant;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassSummaryCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(Constant.SIZE_08),
        onTap: onTap ??
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RestaurantDetailsScreen(restaurant: restaurant),
                ),
              );
            },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: Constant.CONTAINER_SIZE_60,
              height: Constant.CONTAINER_SIZE_60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constant.SIZE_08),
                image: const DecorationImage(
                  image: AssetImage("assets/images/resturant.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.ramen_dining,
                        size: Constant.CONTAINER_SIZE_12,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: Constant.SIZE_04),
                      Text(
                        restaurant.containerCount.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                          fontSize: Constant.LABEL_TEXT_SIZE_14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Constant.SIZE_02),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: Constant.CONTAINER_SIZE_12,
                        color: Colors.grey.shade600,
                      ),
                      SizedBox(width: Constant.SIZE_04),
                      Expanded(
                        child: Text(
                          restaurant.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            fontSize: Constant.CONTAINER_SIZE_12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
