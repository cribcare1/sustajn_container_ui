import 'package:container_tracking/order_request_screen/models/deliver_data.dart';
import 'package:container_tracking/order_request_screen/models/deliver_order_model.dart';
import 'package:container_tracking/order_request_screen/models/pending_detail_data.dart';
import 'package:container_tracking/order_request_screen/models/reject_order_model.dart';
import 'package:container_tracking/order_request_screen/provider_service/order_request_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../constants/imports.util.dart';
import '../../constants/network_urls.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../models/approve_order_data.dart';
import '../models/confirm_detail_data.dart';
import '../models/confirm_model.dart';
import '../models/deliver_details_data.dart';
import '../models/pending_model.dart';
import '../models/reject_data.dart';
import '../models/reject_detail_data.dart';
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
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Confirm OrderDetails Provider

final getConfirmDetailsProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    ConfirmDetailsData responseData = await serviceProvider.getConfirmDetailOrderService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setConfirmDetailsData(responseData);
    } else {
      orderRequestNotifier.setIsLoading(false);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Deliver Detail Provider

final getDeliverDetailProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    DeliverDetailData responseData = await serviceProvider.getDeliverDetailOrderService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setDeliverDetailData(responseData);
    } else {
      orderRequestNotifier.setIsLoading(false);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Reject Detail Provider
final getRejectDetailProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    RejectDetailsData responseData = await serviceProvider.getRejectDetailOrderService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setRejectDetailsData(responseData);
    } else {
      orderRequestNotifier.setIsLoading(false);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Approve Order Provider
final getApproveOrderProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async{
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    final partUrl = '${NetworkUrls.APPROVE_ORDER}';
    ApproveOrder responseData = await serviceProvider.getApproveOrderService(partUrl, params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setApproveOrder(responseData);
      Utils.showToast(responseData.message!);
      Navigator.pop(orderRequestNotifier.context);
      Navigator.pop(orderRequestNotifier.context);
    } else {
      orderRequestNotifier.setIsLoading(false);
      Utils.showToast(responseData.message!);
      Navigator.pop(orderRequestNotifier.context);
      Navigator.pop(orderRequestNotifier.context);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Reject Provider

final getRejectedOrderProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async{
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    final partUrl = '${NetworkUrls.REJECT_ORDER}';
    RejectData responseData = await serviceProvider.getRejectedOrderService(partUrl, params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setRejectData(responseData);
      Utils.showToast(responseData.message!);
      Navigator.pop(orderRequestNotifier.context);
      Navigator.pop(orderRequestNotifier.context);
    } else {
      orderRequestNotifier.setIsLoading(false);
      Utils.showToast(responseData.message!);
      Navigator.pop(orderRequestNotifier.context);
      Navigator.pop(orderRequestNotifier.context);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

//Mark as Delivered Provider

final getMarkDeliverOrderProvider = FutureProvider.family<dynamic,  String>((ref, params) async{
  final orderRequestNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    DeliversData responseData = await serviceProvider.getMarkDeliverOrderService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setDeliversData(responseData);
      Utils.showToast(responseData.message!);
      Navigator.pop(orderRequestNotifier.context);
      Navigator.pop(orderRequestNotifier.context);
    } else {
      orderRequestNotifier.setIsLoading(false);
      Utils.showToast(responseData.message!);
      Navigator.pop(orderRequestNotifier.context);
      Navigator.pop(orderRequestNotifier.context);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    orderRequestNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(orderRequestNotifier.context, e.toString());
  }
});

