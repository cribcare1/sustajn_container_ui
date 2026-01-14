
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/network_urls.dart';
import '../models/delete_address_model.dart';
import '../models/profile_model.dart';
import '../models/profile_update_data.dart';
import '../network/ApiCallPresentator.dart';
import '../utils/utils.dart';
import 'delete_address_service.dart';

class ProfileService {
  Future<ProfileData> getProfileService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = ProfileData.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("get profile data service  service::::$e");
      throw Exception(e);
    }
  }

  Future<UpdateProfileData> profileUpdateService(String partUrl,
      Map<String, dynamic> requestData, String requestKey, var image) async {
    try {
      Utils.printLog("requestData::::::: $requestData");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.putMultipartApiRequest(
          url, requestData, requestKey, image);
      if (response != null) {
        var responseData = UpdateProfileData.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog(" update profile service::::$e");
      throw Exception(e);
    }
  }


  Future<DeleteAddressModel> deleteAddress(
      String url,
      Map<String, dynamic> requestData,

      ) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        var responseData = DeleteAddressModel.fromJson(response);
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

final getProfileApiService = Provider<ProfileService>(
      (ref) => ProfileService(),
);

