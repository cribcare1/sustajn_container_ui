import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/container_history_data.dart';
import '../models/get_container_data.dart';
import '../notifier/order_notifier.dart';
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
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      orderState.setIsLoading(false);
      orderState.setOrderData(responseData);
    } else {
      orderState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return responseData;
  } catch (e) {
    Utils.printLog("Get Profile provider error called: $e");
    orderState.setIsLoading(false);
    Utils.showNetworkErrorToast(orderState.context, e.toString());
  }
});


final getContainerHistoryProvider = FutureProvider.family<dynamic, String>((ref,
    params,
    ) async {
  final containerState = ref.watch(orderProvider);
  try {
    var serviceProvider = ref.read(getOrderApiProvider);
    Utils.printLog("params===$params");
    ContainerHistoryData responseData = await serviceProvider.getContaineHistoryService(params,
    );
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