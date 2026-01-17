import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/network_urls.dart';
import '../models/bankdetails_data.dart';
import '../models/feedback_model.dart';
import '../models/login_model.dart';
import '../network/ApiCallPresentator.dart';
import '../utils/utils.dart';

class AddressService {
  Future<dynamic> createAddressService(String url, Map<String, dynamic> requestData, String requestType) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      Utils.printLog("login service::::$e");
      throw Exception(e);
    }
  }

  Future<dynamic> updateAddressService(String url, Map<String, dynamic> requestData, String requestType) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      Utils.printLog("login service::::$e");
      throw Exception(e);
    }
  }
}

final addressApiService = Provider<AddressService>(
      (ref) => AddressService(),
);
