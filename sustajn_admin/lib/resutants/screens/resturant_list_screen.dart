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
    return Scaffold(
      appBar: CustomAppBar(
        title: Strings.RESTURANT_TITLE,
        leading: SizedBox.shrink(),
        action: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
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
                    // Container(
                    //   height: Constant.TEXT_FIELD_HEIGHT,
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey.shade100,
                    //     borderRadius: BorderRadius.circular(
                    //       Constant.CONTAINER_SIZE_10,
                    //     ),
                    //   ),
                    //   child: TextField(
                    //     decoration: InputDecoration(
                    //       prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                    //       hintText: Strings.SEARCH_RESTURANTS,
                    //       border: InputBorder.none,
                    //       contentPadding: EdgeInsets.symmetric(
                    //         horizontal: Constant.CONTAINER_SIZE_16,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(height: Constant.CONTAINER_SIZE_16),
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
                        child: ListView.separated(
                          itemCount: restaurantState.restaurantList.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: Constant.CONTAINER_SIZE_10),
                          itemBuilder: (context, index) {
                            return _buildRestaurantCard(restaurantState.restaurantList[index]);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRestaurantCard(RestaurantData restaurant) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Constant.CONTAINER_SIZE_12,
        horizontal: Constant.SIZE_008,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  RestaurantDetailsScreen(restaurant: restaurant),
            ),
          );
        },
        leading: Container(
          width: Constant.CONTAINER_SIZE_50,
          height: Constant.CONTAINER_SIZE_50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Constant.SIZE_08),
            image: DecorationImage(
              image: AssetImage("assets/images/resturant.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          restaurant.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            SizedBox(height: Constant.SIZE_02),
            Row(
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: Constant.CONTAINER_SIZE_12,
                      color: Colors.grey.shade500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
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
