import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_customer/provider/search_res_provider/search_res_notifier.dart';

import '../../models/resturant_address_model.dart';
import '../../service/search_res_service.dart';
import '../../utils/utils.dart';


final searchResProvider = ChangeNotifierProvider<SearchResState>((res) => SearchResState());

final searchRes =
FutureProvider.family<List<SearchData>, Map<String, dynamic>>(
        (ref, body) async {
      final provider = ref.read(searchResProvider);
      final service = ref.read(searchRestaurantService);
      try {
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