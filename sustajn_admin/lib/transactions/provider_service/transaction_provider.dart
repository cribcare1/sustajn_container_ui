import 'package:container_tracking/transactions/provider_service/transaction_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../models/transaction_extendedfee_data.dart';
import '../models/transaction_sold_data.dart';
import '../models/transaction_subscription_data.dart';
import 'transaction_notifier.dart';

final transactionProvider = ChangeNotifierProvider(
  (ref) => TransactionNotifier(),
);

final getSubscriptionProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final orderRequestNotifier = ref.watch(transactionProvider);
  try {
    var serviceProvider = ref.read(transactionServices);
    Utils.printLog("params===$params");
    SubscriptionData responseData = await serviceProvider
        .getSubscriptionService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      orderRequestNotifier.setIsLoading(false);
      orderRequestNotifier.setSubscriptionData(responseData);
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

final getTransactionSoldDataList = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final transactionNotifier = ref.watch(transactionProvider);
  try {
    var serviceProvider = ref.read(transactionServices);
    Utils.printLog("params===$params");
    ExtendedFeeData responseData = await serviceProvider.getExtendedFeeService(
      params,
    );
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      transactionNotifier.setIsLoading(false);
      transactionNotifier.setExtendedFeeData(responseData);
    } else {
      transactionNotifier.setIsLoading(false);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    transactionNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(transactionNotifier.context, e.toString());
  }
});

final getExtendedFeeProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final transactionNotifier = ref.watch(transactionProvider);
  try {
    var serviceProvider = ref.read(transactionServices);
    Utils.printLog("params===$params");
    ExtendedFeeData responseData = await serviceProvider.getExtendedFeeService(
      params
    );
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      transactionNotifier.setIsLoading(false);
      transactionNotifier.setExtendedFeeData(responseData);
    } else {
      transactionNotifier.setIsLoading(false);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    transactionNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(transactionNotifier.context, e.toString());
  }
});
