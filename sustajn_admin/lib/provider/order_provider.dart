import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../constants/string_utils.dart';
import '../notifier/order_notifier.dart';
import '../product_screen/models/incirculation_data.dart';
import '../product_screen/models/incirculation_detail_data.dart';
import '../product_screen/models/inventory_details_data.dart';
import '../product_screen/models/inventory_order_data.dart';
import '../product_screen/models/with_partner_data.dart';
import '../product_screen/models/withpartner_detail_data.dart';
import '../resutants/models/get_container_data.dart';
import '../service/order_service.dart';
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
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
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
    var responseData = await serviceProvider.fetchContainerCount(
      params['restaurantId'],
      params['productId'],
    );
    if (responseData['message'] != null &&
        responseData['message']!.isNotEmpty &&
        responseData['message'].toLowerCase() == Strings.SUCCESS) {
      orderState.setIsLoading(false);
      orderState.setLeaseCount(responseData['data']['leasedContainerCount']);
      orderState.setReturnCount(responseData['data']['returnedContainerCount']);
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

/// Incirculation Provider
final getInCirculationProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final orderState = ref.watch(orderProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    InCirculationData responseData = await serviceProvider
        .getInCirculationOrderService(params);
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
      orderState.setIsLoading(false);
      orderState.setInCirculationData(responseData);
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

/// With Partner Provider

final getWithPartnerOrderProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final orderState = ref.watch(orderProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    WithPartnerData responseData = await serviceProvider
        .getWithPartnerOrderService(params);
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
      orderState.setIsLoading(false);
      orderState.setWithPartnerData(responseData);
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

///Damaged provider

// final getDamagedOrderProvider = FutureProvider.family<dynamic, String>((
//     ref,
//     params,
//     ) async {
//   final orderState = ref.watch(orderProvider);
//   try {
//     var serviceProvider = ref.read(getOrderApiProvider);
//     Utils.printLog("params===$params");
//     DamagedContainerData responseData = await serviceProvider.getDamagedOrderService(
//       params,
//     );
//     if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
//       orderState.setIsLoading(false);
//       orderState.setDamagedData(responseData);
//     } else {
//       orderState.setIsLoading(false);
//       Utils.showToast(responseData.message!);
//     }
//     return null;
//   } catch (e) {
//     Utils.printLog("Get Profile provider error called: $e");
//     orderState.setIsLoading(false);
//     Utils.showNetworkErrorToast(orderState.context, e.toString());
//   }
// });

///Sold provider

// final getSoldOrderProvider = FutureProvider.family<dynamic, String>((
//     ref,
//     params,
//     ) async {
//   final orderState = ref.watch(orderProvider);
//   try {
//     var serviceProvider = ref.read(getOrderApiProvider);
//     Utils.printLog("params===$params");
//     SoldContainersData responseData = await serviceProvider.getSoldOrderService(
//       params,
//     );
//     if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
//       orderState.setIsLoading(false);
//       orderState.setSoldContainersData(responseData);
//     } else {
//       orderState.setIsLoading(false);
//       Utils.showToast(responseData.message!);
//     }
//     return null;
//   } catch (e) {
//     Utils.printLog("Get Profile provider error called: $e");
//     orderState.setIsLoading(false);
//     Utils.showNetworkErrorToast(orderState.context, e.toString());
//   }
// });

///Incirculation details provider

final getIncirculationListProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final orderState = ref.watch(orderProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    IncirculationDetailsData responseData = await serviceProvider
        .getInCirculationListOrderService(params);
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
      orderState.setIsLoading(false);
      orderState.setIncirculationDetailsData(responseData);
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

///With partner details provider

final getWithPartnerDetailProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final orderState = ref.watch(orderProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    WithPartnerDetailsData responseData = await serviceProvider
        .getWithPartnerDetailOrderService(params);
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
      orderState.setIsLoading(false);
      orderState.setWithPartnerDetailsData(responseData);
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

///Inventory Details Provider

final getInventoryDetailProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final orderState = ref.watch(orderProvider);

  try {
    var serviceProvider = ref.read(getOrderApiProvider);

    Utils.printLog("params===$params");

    InventoryDetailsData responseData = await serviceProvider
        .getInventoryOrdersService(params);

    orderState.setIsLoading(false);
    orderState.setInventoryDetailsData(responseData);

    return responseData;
  } catch (e) {
    Utils.printLog("Get Profile provider error called: $e");
    orderState.setIsLoading(false);
    Utils.showNetworkErrorToast(orderState.context, e.toString());
  }
});

///Inventory Order Provider
final getInventoryOrderProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final orderState = ref.watch(orderProvider);

  try {
    var serviceProvider = ref.read(getOrderApiProvider);

    Utils.printLog("params===$params");

    InventoryOrderData responseData = await serviceProvider
        .getInventoryOrderedService(params);

    orderState.setIsLoading(false);
    orderState.setInventoryOrderData(responseData);

    return responseData;
  } catch (e) {
    Utils.printLog("Get Profile provider error called: $e");
    orderState.setIsLoading(false);
    Utils.showNetworkErrorToast(orderState.context, e.toString());
  }
});
