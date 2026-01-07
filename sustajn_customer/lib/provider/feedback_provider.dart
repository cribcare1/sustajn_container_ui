import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_customer/notifier/feedback_notifier.dart';
import 'package:sustajn_customer/service/feedback_service.dart';

import '../constants/network_urls.dart';
import '../utils/utils.dart';

final feedbackNotifier = ChangeNotifierProvider((ref) => FeedbackNotifier());

final feedbackProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.watch(feedbackApiService);
  final feedbackState = ref.watch(feedbackNotifier);

  try {
    var url = '${NetworkUrls.BASE_URL}${NetworkUrls.CREATE_FEEDBACK}';
    var responseData = await apiService.createFeedback(url, params);
    // Utils.printLog(params);

    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.trim().toString().toLowerCase() ==
            NetworkUrls.SUCCESS) {
      feedbackState.setIsLoading(false);
      // feedbackState.setSubscriptionModel(responseData);
    } else {
      if (!feedbackState.context!.mounted) return;
      showCustomSnackBar(
        context: feedbackState!.context,
        message: responseData.message!,
        color: Colors.black,
      );
      feedbackState.setIsLoading(false);
    }
  } catch (e) {
    feedbackState.setIsLoading(false);
    Utils.showNetworkErrorToast(feedbackState.context, e.toString());
  } finally {
    feedbackState.setIsLoading(false);
  }
  return null;
});
