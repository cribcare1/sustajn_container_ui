import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../constants/string_utils.dart';
import '../../../../utils/utility.dart';
import '../../model/get_all_restaurant_data.dart';
import '../../model/restaurant_details_data.dart';
import '../../service/restaurant_list_service.dart';
import '../notifier/restaurant_notifier.dart';

final restaurantProvider = ChangeNotifierProvider((ref) => RestaurantListState());

final getRestaurantListProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final restaurantState = ref.watch(restaurantProvider);
  try {
    var serviceProvider = ref.read(getRestaurantApiProvider);
    Utils.printLog("params===$params");
    GetRestaurantData responseData = await serviceProvider.getRestaurantService(
      params,
    );
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      restaurantState.setIsLoading(false);
      restaurantState.setRestaurantData(responseData);
    } else {
      restaurantState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Restaurant provider error called: $e");
    restaurantState.setIsLoading(false);
    Utils.showNetworkErrorToast(restaurantState.context, e.toString());
  }
});

final getRestaurantDtlsProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final restaurantState = ref.watch(restaurantProvider);
  try {
    var serviceProvider = ref.read(getRestaurantApiProvider);
    Utils.printLog("params===$params");
    RestaurantDetailsData responseData = await serviceProvider.getRestaurantDtlsService(
      params,
    );
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      restaurantState.setIsLoading(false);
      restaurantState.setRestaurantDtlsData(responseData);
    } else {
      restaurantState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Restaurant provider error called: $e");
    restaurantState.setIsLoading(false);
    Utils.showNetworkErrorToast(restaurantState.context, e.toString());
  }
});