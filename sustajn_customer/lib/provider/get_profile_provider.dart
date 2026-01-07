import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_customer/notifier/feedback_notifier.dart';
import 'package:sustajn_customer/service/feedback_service.dart';

import '../constants/network_urls.dart';
import '../notifier/get_profile_notifier.dart';
import '../notifier/subscription_notifier.dart';
import '../service/get_profile_service.dart';
import '../service/subscription_service.dart';
import '../utils/utils.dart';

final getProfileNotifier = ChangeNotifierProvider((ref) => GetProfileNotifier());

final getProfileProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final apiService = ref.watch(getProfileApiService);
  final getProfileState = ref.watch(getProfileNotifier);

  try {
    var url = '${NetworkUrls.BASE_URL}${NetworkUrls.UPGRADE_SUBSCRIPTION}';
    var responseData = await apiService.createSubscription(url, params);
    // Utils.printLog(params);

    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.trim().toString().toLowerCase() ==
            NetworkUrls.SUCCESS) {
      getProfileState.setIsLoading(false);
      // feedbackState.setSubscriptionModel(responseData);
    } else {
      if (!getProfileState.context!.mounted) return;
      showCustomSnackBar(
        context: getProfileState!.context,
        message: responseData.message!,
        color: Colors.black,
      );
      getProfileState.setIsLoading(false);
    }
  } catch (e) {
    getProfileState.setIsLoading(false);
    Utils.showNetworkErrorToast(getProfileState.context, e.toString());
  } finally {
    getProfileState.setIsLoading(false);
  }
  return null;
});
