import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/model/plan_model.dart';
import '../constants/network_urls.dart';
import '../models/register.dart';
import '../network/ApiCallPresentator.dart';
import '../utils/utility.dart';
import '../models/login_model.dart';

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
  Future<Register> registerUser(String partUrl, Map<String, dynamic> requestData, String requestKey, var image) async {
    try {
      Utils.printLog("requestData::::::: $requestData");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postMultipartRequestAdmin(url,File(image), requestData, requestKey,"");
      if (response != null) {
        var responseData = Register.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      throw Exception(e);
    }
  }
  // Future<dynamic> registrationUser(String url, Map<String, dynamic> requestData, String requestType) async {
  //   try {
  //     ApiCallPresenter presenter = ApiCallPresenter();
  //     var response = await presenter.postLoginRequest_old(url, requestData);
  //     if (response != null) {
  //       return response;
  //     } else {
  //       throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
  //     }
  //   }catch(e){
  //     Utils.printLog("login service::::$e");
  //     throw Exception(e);
  //   }
  // }

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
  Future<List<PlanModel>?> planServices()async{

    var api = "${NetworkUrls.BASE_URL}${NetworkUrls.SUBSCRIPTION_LIST}";
    try{
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(api);
      if(response != null){
        final List list = response['data'] ?? [];
        return list
            .map((e) => PlanModel.fromJson(e))
            .toList();
      }else{
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){throw Exception(e);}
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
}

final loginApiProvider = Provider<AuthServices>((ref) => AuthServices());