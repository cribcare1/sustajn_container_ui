import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_customer/notifier/feedback_notifier.dart';
import 'package:sustajn_customer/service/feedback_service.dart';

import '../constants/network_urls.dart';
import '../notifier/subscription_notifier.dart';
import '../service/subscription_service.dart';
import '../utils/utils.dart';

final subscriptionNotifier = ChangeNotifierProvider((ref) => SubscriptionNotifier());

final feedbackProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final apiService = ref.watch(subscriptionApiService);
  final subscriptionState = ref.watch(subscriptionNotifier);

  try {
    var url = '${NetworkUrls.BASE_URL}${NetworkUrls.UPGRADE_SUBSCRIPTION}';
    var responseData = await apiService.createSubscription(url, params);
    // Utils.printLog(params);

    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.trim().toString().toLowerCase() ==
            NetworkUrls.SUCCESS) {
      subscriptionState.setIsLoading(false);
      // feedbackState.setSubscriptionModel(responseData);
    } else {
      if (!subscriptionState.context!.mounted) return;
      showCustomSnackBar(
        context: subscriptionState!.context,
        message: responseData.message!,
        color: Colors.black,
      );
      subscriptionState.setIsLoading(false);
    }
  } catch (e) {
    subscriptionState.setIsLoading(false);
    Utils.showNetworkErrorToast(subscriptionState.context, e.toString());
  } finally {
    subscriptionState.setIsLoading(false);
  }
  return null;
});
