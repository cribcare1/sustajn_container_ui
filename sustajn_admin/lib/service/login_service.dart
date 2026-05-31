import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/model/login_model.dart';
import '../constants/network_urls.dart';
import '../network/ApiCallPresentor.dart';
import '../utils/utility.dart';

class AuthServices {
  Future<dynamic> loginUser(String url, Map<String, dynamic> requestData,
      String requestType) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        var responseData = LoginModel.fromJson(response);
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