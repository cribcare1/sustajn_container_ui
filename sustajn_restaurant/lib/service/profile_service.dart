import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';

import '../constants/network_urls.dart';
import '../models/update_address_data.dart';
import '../models/update_profile_data.dart';
import '../network/ApiCallPresentator.dart';
import '../utils/utility.dart';

class ProfileServices {

  Future<GetProfileData> getProfileService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = GetProfileData.fromJson(response);
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

  Future<UpdateProfileData> profileUpdateService(
      String url, Map<String, dynamic> requestData, String requestType) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postMultipartRequestAdmin(url, null, requestData, requestType, "userData");
      print("Response: $response");
      if (response != null) {
        var responseData = UpdateProfileData.fromJson(response);
        Utils.printLog("responseData in Service: ${responseData.status}");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Profile update service::::$e");
      throw Exception(e);
    }
  }

  Future<UpdateProfileData> updateImageService(String partUrl, Map<String, dynamic> requestData, String requestKey, var image) async {
    try {
      Utils.printLog("requestData::::::: $requestData");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postMultipartRequestAdmin(url, File(image), requestData, requestKey,"");
      if (response != null) {
        var responseData = UpdateProfileData.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      Utils.printLog(" Update image service::::$e");
      throw Exception(e);
    }
  }

  Future<dynamic> addressService(String url, Map<String, dynamic> requestData) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postLoginRequest_old(url, requestData);
      if (response != null) {
        var responseData = UpdateProfAddressData.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      Utils.printLog("profile address update service::::$e");
      throw Exception(e);
    }
  }
}



final getProfileApiProvider = Provider<ProfileServices>((ref) => ProfileServices());