import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/network_urls.dart';
import '../models/feedback_model.dart';
import '../models/login_model.dart';
import '../models/upgrade_scubscription_model.dart';
import '../network/ApiCallPresentator.dart';
import '../utils/utils.dart';

class SubscriptionService {
  Future<UpgradeSubscriptionModel> createSubscription(
      String url,
      Map<String, dynamic> requestData,

      ) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        var responseData = UpgradeSubscriptionModel.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("login service::::$e");
      throw Exception(e);
    }
  }
}

final subscriptionApiService = Provider<SubscriptionService>(
      (ref) => SubscriptionService(),
);
