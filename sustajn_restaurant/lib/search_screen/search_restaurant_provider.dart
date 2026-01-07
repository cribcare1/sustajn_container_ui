import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_restaurant/search_screen/search_restaurant_service.dart';
import 'package:sustajn_restaurant/search_screen/search_restaurant_state.dart';
import 'package:sustajn_restaurant/search_screen/search_restaurant_model.dart';

import '../utils/utility.dart';

final searchResProvider = ChangeNotifierProvider<SearchRestaurantState>((res) => SearchRestaurantState());

final searchRes =
FutureProvider.family<List<SearchData>, Map<String, dynamic>>(
        (ref, body) async {
      final provider = ref.read(searchResProvider);
      final service = ref.read(searchRestaurantService);
      try {
        // provider.setLoading(true);
        final response = await service.searchRestaurant(body);
        provider.setRestaurant(response!);
        return response;
      } catch (e) {
        if (provider.context?.mounted ?? false) {
          Utils.showNetworkErrorToast(
            provider.context!,
            e.toString(),
          );
        }
        provider.setError(e.toString());
        return [];
      } finally {
        provider.setLoading(false);
      }
    });

