import 'package:container_tracking/order_request_screen/provider_service/order_request_service.dart';
import 'package:container_tracking/transactions/provider_service/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../Screen/users/model/user_sold_container_data.dart';
import '../../Screen/users/model/users_data.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../models/transaction_extendedfee_data.dart';
import '../models/transaction_sold_data.dart';
import '../models/transaction_subscription_data.dart';
import 'transaction_notifier.dart';

final transactionProvider = ChangeNotifierProvider((ref) => TransactionNotifier());

final getSubscriptionProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(transactionProvider);
  try {
    var serviceProvider = ref.read(transactionServices);
    Utils.printLog("params===$params");
    SubscriptionData responseData = await serviceProvider.getSubscriptionService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setSubscriptionData(responseData);
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

final getTransactionSoldDataList = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(transactionProvider);
  try {
    var serviceProvider = ref.read(transactionServices);
    Utils.printLog("params===$params");
    TransactionSoldData responseData = await serviceProvider.getSoldService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setSoldContainerData(responseData);
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

final getExtendedFeeProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final orderRequestNotifier = ref.watch(transactionProvider);
  try {
    var serviceProvider = ref.read(transactionServices);
    Utils.printLog("params===$params");
    ExtendedFeeData responseData = await serviceProvider.getExtendedFeeService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setExtendedFeeData(responseData);
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