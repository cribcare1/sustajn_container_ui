import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/network_urls.dart';
import '../network/ApiCallPresentor.dart';
import 'models/restaurant_list_model.dart';

class RestaurantServices {
  Future<dynamic> fetchRestaurant(String url) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = RestaurantListModel.fromJson(response);
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

final restaurantApiProvider = Provider<RestaurantServices>(
  (ref) => RestaurantServices(),
);
