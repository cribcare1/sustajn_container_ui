import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_restaurant/lottie_animation/account_create_animation.dart';

import '../constants/imports_util.dart';
import '../constants/network_urls.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../lottie_animation/container_order_animation.dart';
import '../models/container_history_data.dart';
import '../models/get_container_data.dart';
import '../notifier/order_notifier.dart';
import '../service/order_service.dart';
import '../utils/nav_utils.dart';
import '../utils/utility.dart';

final orderProvider = ChangeNotifierProvider((ref) => OrderState());

final getOrderProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final orderState = ref.watch(orderProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    GetContainerData responseData = await serviceProvider.getOrderService(
      params,
    );
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      orderState.setIsLoading(false);
      orderState.setOrderData(responseData);
    } else {
      orderState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Profile provider error called: $e");
    orderState.setIsLoading(false);
    Utils.showNetworkErrorToast(orderState.context, e.toString());
  }
});
/// Container count ///
final getContainerCount = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final orderState = ref.watch(orderProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    var responseData = await serviceProvider.fetchContainerCount(params['restaurantId'],
      params['productId']
    );
    if (responseData['status'] != null && responseData['status']!.isNotEmpty && responseData['status'].toLowerCase() == Strings.SUCCESS) {
      orderState.setIsLoading(false);
      orderState.setLeaseCount(responseData['data']['leasedContainerCount']);
      orderState.setReturnCount(responseData['data']['returnedContainerCount']);
      print(responseData);
    } else {
      orderState.setIsLoading(false);
      Utils.showToast(responseData['message']!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Profile provider error called: $e");
    orderState.setIsLoading(false);
    Utils.showNetworkErrorToast(orderState.context, e.toString());
  }
});
///

final getContainerHistoryProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final containerState = ref.watch(orderProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    ContainerHistoryData responseData = await serviceProvider
        .getContaineHistoryService(params);
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      containerState.setIsLoading(false);
      containerState.setContainerHistoryData(responseData);
    } else {
      containerState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return responseData;
  } catch (e) {
    Utils.printLog("Get Profile provider error called: $e");
    containerState.setIsLoading(false);
    Utils.showNetworkErrorToast(containerState.context, e.toString());
  }
});

// final addReturnProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
//   ref,
//   params,
// ) async {
//   final apiService = ref.read(getOrderApiProvider);
//
//   final url = '${NetworkUrls.BASE_URL}${NetworkUrls.ADD_RETURN_CONTAINER}';
//
//   Utils.printLog("Provider url : $url");
//   final responseData = await apiService.addReturnService(url, params, "");
//   final status = responseData["status"];
//   final message = responseData['message'];
//   if (status != null &&
//       status.isNotEmpty &&
//       status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
//
//   }
//
//   print("Provider Response: $responseData");
//   return responseData;
// });

final addReturnProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {

  final apiService = ref.watch(getOrderApiProvider);
  final orderState = ref.watch(orderProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.ADD_RETURN_CONTAINER}';

  try {
    var responseData =
    await apiService.addReturnService(url, params, "");

    final success = responseData['success'];
    final message = responseData['message'];

    if (success == true) {

      orderState.setIsLoading(false);
      orderState.setOrdering(false);
      orderState.clearSelectedContainers();
      if (!orderState.context.mounted) return ;

      NavUtil.navigateToPushScreen(
        orderState.context,
        ContainerOrderScreen(
          title: Strings.THANK_YOU_TXT,
          subTitle:
          Strings.ADD_ORDER_TXT,
        ),
      );
    } else {

      orderState.setIsLoading(false);
      orderState.setOrdering(false);

      if (!orderState.context.mounted) return null;

      showCustomSnackBar(
        context: orderState.context,
        message: message ?? "Something went wrong",
        color: Colors.red,
      );
    }
  } catch (e) {
    orderState.setIsLoading(false);
    orderState.setOrdering(false);

    Utils.showNetworkErrorToast(
        orderState.context, e.toString());
  }

  return null;
});

