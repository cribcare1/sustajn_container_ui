import 'package:container_tracking/Screen/Partner/provider/notifier/product_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../constants/string_utils.dart';
import '../../../../utils/utility.dart';
import '../../model/container_history_data.dart';
import '../../model/get_container_data.dart';
import '../../service/product_service.dart';

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
    Utils.printLog("lease screens provider error called: $e");
    containerState.setIsLoading(false);
    Utils.showNetworkErrorToast(containerState.context, e.toString());
  }
});

final returnedContainerProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final containerState = ref.watch(orderProvider);
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