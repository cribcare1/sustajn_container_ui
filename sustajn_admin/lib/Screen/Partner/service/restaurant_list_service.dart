import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/network_urls.dart';
import '../../../network/ApiCallPresentor.dart';
import '../../../utils/utility.dart';
import '../model/get_all_restaurant_data.dart';
import '../model/restaurant_details_data.dart';

class RestaurantServices {
  Future<GetRestaurantData> getRestaurantService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = GetRestaurantData.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Profile service::::$e");
      throw Exception(e);
    }
  }

  Future<RestaurantDetailsData> getRestaurantDtlsService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = RestaurantDetailsData.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
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
  final getRestaurantApiProvider = Provider<RestaurantServices>((ref) => RestaurantServices());
