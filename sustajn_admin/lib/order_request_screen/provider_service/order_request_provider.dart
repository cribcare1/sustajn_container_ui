import 'package:container_tracking/order_request_screen/models/deliver_order_model.dart';
import 'package:container_tracking/order_request_screen/models/pending_detail_data.dart';
import 'package:container_tracking/order_request_screen/models/reject_order_model.dart';
import 'package:container_tracking/order_request_screen/provider_service/order_request_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../Screen/users/model/users_data.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../models/confirm_model.dart';
import '../models/pending_model.dart';
import 'order_request_notifier.dart';

final orderRequestProvider = ChangeNotifierProvider((ref) => OrderRequestNotifier());

final getPendingOrderProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    PendingData responseData = await serviceProvider.getPendingOrderService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setPendingData(responseData);
    } else {
      orderRequestNotifier.setIsLoading(false);
      //Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Confirm order provider
final getConfirmOrderProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    ConfirmData responseData = await serviceProvider.getConfirmOrderService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setConfirmData(responseData);
    } else {
      orderRequestNotifier.setIsLoading(false);
      //Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Deliver order provider

final getDeliverOrderProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    DeliverData responseData = await serviceProvider.getDeliverOrderService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setDeliverData(responseData);
    } else {
      orderRequestNotifier.setIsLoading(false);
      //Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Reject order provider

final getRejectOrderProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    RejectOrderData responseData = await serviceProvider.getRejectOrderService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setRejectOredrData(responseData);
    } else {
      orderRequestNotifier.setIsLoading(false);
      //Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Pending OrderDetails Provider
final getPendingDetailsProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    PendingDetailsData responseData = await serviceProvider.getPendingDetailOrderService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setPendingDetailsData(responseData);
    } else {
      orderRequestNotifier.setIsLoading(false);
      //Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});
