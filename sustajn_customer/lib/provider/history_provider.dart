import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_customer/service/history_service.dart';

import '../profile_screen/history_screen/model/sold_container_data.dart';
import '../utils/utils.dart';
import '../notifier/history_notifier.dart';

final historyProvider = ChangeNotifierProvider((ref) => HistoryNotifier());


final borrowedProvider = FutureProvider.family<dynamic, String>(
      (ref, params) async {
    final borrowedState = ref.watch(historyProvider);
    try {
      var serviceProvider = ref.read(historyServiceProvider);
      Utils.printLog("params===$params");
      var responseData = await serviceProvider.borrowedService(params);
      if (responseData.status != null && responseData.status!.isNotEmpty ) {
        borrowedState.setIsLoading(false);
        borrowedState.setBorrowedData(responseData);

      }else{
        borrowedState.setIsLoading(false);
        Utils.showToast(responseData.message!);
      }
    } catch (e) {
      Utils.printLog("Get borrowed provider error called: $e");
      borrowedState.setIsLoading(false);
      Utils.showNetworkErrorToast(borrowedState.context, e.toString());
    }
  },
);

final getSoldContainerProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final containerState = ref.watch(historyProvider);
  try {
    var serviceProvider = ref.read(historyServiceProvider);
    Utils.printLog("params===$params");
    SoldContainerData responseData = await serviceProvider
        .getSoldContainerService(params);
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      containerState.setIsLoading(false);
      containerState.setSoldContainerData(responseData);
    } else {
      containerState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return responseData;
  } catch (e) {
    Utils.printLog("Get sold provider error called: $e");
    containerState.setIsLoading(false);
    Utils.showNetworkErrorToast(containerState.context, e.toString());
  }
});
