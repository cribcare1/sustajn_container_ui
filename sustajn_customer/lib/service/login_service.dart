
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/network_urls.dart';
import '../models/login_model.dart';
import '../network/ApiCallPresentator.dart';
import '../utils/utils.dart';

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
  Future<dynamic> registerUser(String url, Map<String, dynamic> requestData, String requestType, File? file) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postMultipartRequestAdmin(url,file!, requestData,"",requestType);
      if (response != null) {
        print("===========++=============$response");
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      Utils.printLog("rgister resturant service::::$e");
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