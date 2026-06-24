
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Screen/users/model/users_data.dart';
import '../../constants/network_urls.dart';
import '../../network/ApiCallPresentor.dart';
import '../../utils/utility.dart';

class OrderRequestServices {

  Future<UsersData> getPendingOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = UsersData.fromJson(response);
        Utils.printLog("User responseData in Service: ${responseData.status}");

        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Profile service::::$e");
      throw Exception(e);
    }
  }
}

final orderRequestServices = Provider<OrderRequestServices>((ref) => OrderRequestServices());