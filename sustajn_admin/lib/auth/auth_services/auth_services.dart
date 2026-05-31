import 'package:container_tracking/auth/model/login_model.dart';
import 'package:container_tracking/constants/network_urls.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/ApiCallPresentor.dart';
import '../../utils/utility.dart';

class AuthServices {
  Future<dynamic> loginUser(String url, Map<String, dynamic> requestData, String requestType) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postLoginRequest_old(url, requestData);
      if (response != null) {
        var responseData = LoginModel.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      Utils.printLog("login service::::$e");
      throw Exception(e);
    }
  }
  Future<dynamic> registrationUser(String url, Map<String, dynamic> requestData, String requestType) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postLoginRequest_old(url, requestData);
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
Future<dynamic> forgetPassword(String url, Map<String, dynamic> requestData, String requestType) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postLoginRequest_old(url, requestData);
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
  Future<dynamic> verifyOtp(String url, Map<String, dynamic> requestData, String requestType) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postLoginRequest_old(url, requestData);
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
final loginApiProvider = Provider<AuthServices>((ref) => AuthServices());