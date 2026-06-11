import 'package:container_tracking/Screen/Partner/provider/notifier/product_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../constants/string_utils.dart';
import '../../../../utils/utility.dart';
import '../../model/container_history_data.dart';
import '../../model/get_container_data.dart';
import '../../model/lease_barrow_data.dart';
import '../../service/product_service.dart';
import 'dart:convert';

final productProvider = ChangeNotifierProvider((ref) => OrderState());

final getOrderProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderState = ref.watch(productProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    GetContainerData responseData = await serviceProvider.getOrderService(
      params,
    );

    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
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

final getContainerHistoryProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final containerState = ref.watch(productProvider);
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
    Utils.printLog("lease screens provider error called: $e");
    containerState.setIsLoading(false);
    Utils.showNetworkErrorToast(containerState.context, e.toString());
  }
});

final returnedContainerProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final containerState = ref.watch(productProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    ContainerHistoryData responseData = await serviceProvider
        .returnedContainerService(params);
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      containerState.setIsLoading(false);
      containerState.setContainerHistoryData(responseData);
    } else {
      containerState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return responseData;
  } catch (e) {
    Utils.printLog("lease screens provider error called: $e");
    containerState.setIsLoading(false);
    Utils.showNetworkErrorToast(containerState.context, e.toString());
  }
});

final getContainerByRestaurant = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final containerState = ref.watch(productProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    ContainerHistoryData responseData = await serviceProvider
        .getContainerByRestaurantService(params);
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      containerState.setIsLoading(false);
      containerState.setContainerHistoryData(responseData);
    } else {
      containerState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return responseData;
  } catch (e) {
    Utils.printLog("lease screens provider error called: $e");
    containerState.setIsLoading(false);
    Utils.showNetworkErrorToast(containerState.context, e.toString());
  }
});

final getLeaseBorrowProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderState = ref.watch(productProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    LeaseBarrowData responseData = await serviceProvider.getLeaseBorrowService(
      params,
    );


    final responseString = '''{
    "status": "SUCCESS",
    "message": "Partner graph metrics processed successfully",
    "data": {
        "monthYear": "June-2026",
        "dailyStats": [
            {
                "day": 1,
                "dayName": "Mon",
                "leased": 3,
                "returned": 0
            },
            {
                "day": 2,
                "dayName": "Tue",
                "leased": 3,
                "returned": 1
            },
            {
                "day": 3,
                "dayName": "Wed",
                "leased": 2,
                "returned": 0
            },
            {
                "day": 4,
                "dayName": "Thu",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 5,
                "dayName": "Fri",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 6,
                "dayName": "Sat",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 7,
                "dayName": "Sun",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 8,
                "dayName": "Mon",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 9,
                "dayName": "Tue",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 10,
                "dayName": "Wed",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 11,
                "dayName": "Thu",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 12,
                "dayName": "Fri",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 13,
                "dayName": "Sat",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 14,
                "dayName": "Sun",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 15,
                "dayName": "Mon",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 16,
                "dayName": "Tue",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 17,
                "dayName": "Wed",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 18,
                "dayName": "Thu",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 19,
                "dayName": "Fri",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 20,
                "dayName": "Sat",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 21,
                "dayName": "Sun",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 22,
                "dayName": "Mon",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 23,
                "dayName": "Tue",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 24,
                "dayName": "Wed",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 25,
                "dayName": "Thu",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 26,
                "dayName": "Fri",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 27,
                "dayName": "Sat",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 28,
                "dayName": "Sun",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 29,
                "dayName": "Mon",
                "leased": 0,
                "returned": 0
            },
            {
                "day": 30,
                "dayName": "Tue",
                "leased": 0,
                "returned": 0
            }
        ]
    }
}''';

    // final LeaseBarrowData responseData = LeaseBarrowData.fromJson(jsonDecode(responseString));
    Utils.printLog("On Success==111=${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderState.setIsLoading(false);
      orderState.setLeaseBorrowData(responseData);
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