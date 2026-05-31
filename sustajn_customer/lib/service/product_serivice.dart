import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/network_urls.dart';
import '../models/product_data.dart';
import '../network/ApiCallPresentator.dart';
import '../utils/utils.dart';

class ProductService {
  Future<ProductData> productService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = ProductData.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("product service  service::::$e");
      throw Exception(e);
    }
  }
}

final productServiceProvider = Provider<ProductService>(
      (ref) => ProductService(),
);
