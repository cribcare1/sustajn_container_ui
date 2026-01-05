
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/network_urls.dart';
import '../models/login_model.dart';
import '../models/subscriptionplan_data.dart';
import '../models/user_register_model.dart';
import '../network/ApiCallPresentator.dart';
import '../utils/utils.dart';

class AuthServices {
  Future<dynamic> loginUser(String url, Map<String, dynamic> requestData, String requestType) async {
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
    }catch(e){
      Utils.printLog("login service::::$e");
      throw Exception(e);
    }
  }
  Future<UserRegistration> registerUser(String partUrl, Map<String, dynamic> requestData, String requestKey, var image) async {
    try {
      Utils.printLog("requestData::::::: $requestData");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.putMultipartApiRequest(url, requestData, requestKey, image);
      if (response != null) {
        var responseData = UserRegistration.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      Utils.printLog(" Register service::::$e");
      throw Exception(e);
    }
  }
  Future<dynamic> forgetPassword(String url, Map<String, dynamic> requestData, String requestType) async {
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
  Future<dynamic> verifyOtp(String url, Map<String, dynamic> requestData, String requestType) async {
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

  Future<dynamic> resetPassword(String url, Map<String, dynamic> requestData, String requestType) async {
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

  Future<SubscriptionModel> getSubscriptionPlan(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = SubscriptionModel.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("borrowed service  service::::$e");
      throw Exception(e);
    }
  }
}


final loginApiService = Provider<AuthServices>((ref) => AuthServices());