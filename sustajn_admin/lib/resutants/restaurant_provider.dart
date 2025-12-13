import 'package:container_tracking/resutants/restaurant_services.dart';
import 'package:container_tracking/resutants/restaurant_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../constants/network_urls.dart';
import '../utils/utility.dart';
import 'models/restaurant_list_model.dart';

final restaurantNotifierProvider = ChangeNotifierProvider<RestaurantState>(
  (ref) => RestaurantState(),
);

final fetchRestaurantProvider = FutureProvider.family<void, bool>((ref, isLoadMore) async {
  final apiService = ref.read(restaurantApiProvider);
  final state = ref.read(restaurantNotifierProvider);

  if (state.isLoading || state.isMoreLoading || !state.hasMore) return;

  isLoadMore ? state.setMoreLoading(true) : state.setLoading(true);

  final url =
      '${NetworkUrls.BASE_URL}${NetworkUrls.RESTAURANT_LIST}'
      'page=${state.page}&size=${state.size}';

  try {
    RestaurantListModel response = await apiService.fetchRestaurant(url);

    state.addRestaurants(response.restaurantData);
    state.incrementPage();

  } catch (e) {
    state.setError(e.toString());

    if (state.context?.mounted ?? false) {
      showCustomSnackBar(
        context: state.context!,
        message: e.toString(),
        color: Colors.red,
      );
    }
  } finally {
    state.setLoading(false);
    state.setMoreLoading(false);
  }
});

