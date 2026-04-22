import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/network_urls.dart';
import '../network/ApiCallPresentor.dart';
import '../resutants/models/get_container_data.dart';
import '../utils/utility.dart';

class OrderServices {
  Future<GetContainerData> getOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = GetContainerData.fromJson(response);
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
  Future<Map<String, dynamic>> fetchContainerCount(int restaurantId, int productId) async {
    try {
      String url = "${NetworkUrls.BASE_URL + NetworkUrls.CONTAINER_COUNT}?restaurantId=$restaurantId&productId=$productId";
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Profile service::::$e");
      throw Exception(e);
    }
  }
}
  final getOrderApiProvider = Provider<OrderServices>((ref) => OrderServices());

