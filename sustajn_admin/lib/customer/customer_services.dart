import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/network_urls.dart';
import '../network/ApiCallPresentor.dart';
import 'model/customer_list_model.dart';

class CustomerServices {
  Future<dynamic> fetchCustomer(String url) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = CustomerListModel.fromJson(response);
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

final customerApiProvider = Provider<CustomerServices>(
      (ref) => CustomerServices(),
);