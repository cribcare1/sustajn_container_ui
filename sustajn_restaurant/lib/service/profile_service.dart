import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';

import '../constants/network_urls.dart';
import '../lease_receive/model/container_return_list_model.dart';
import '../models/chart_model.dart';
import '../models/update_address_data.dart';
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

  Future<GetProfileData> profileUpdateService(
      String url, Map<String, dynamic> requestData, String requestType) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postMultipartRequestAdmin(url, null, requestData, requestType, "userData");
      print("Response: $response");
      if (response != null) {
        var responseData = GetProfileData.fromJson(response);
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

  Future<GetProfileData> updateImageService(String partUrl, Map<String, dynamic> requestData, String requestKey, File? image) async {
    try {
      Utils.printLog("requestData::::::: $requestData");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postMultipartRequestAdmin(url, image!, requestData, requestKey,"userData");
      if (response != null) {
        var responseData = GetProfileData.fromJson(response);
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
      var response = await presenter.postApiRequest(url, requestData);

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
Future<dynamic> updatePaymentType(String url, Map<String, dynamic> requestData) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);

      if (response != null) {
        var responseData = GetProfileData.fromJson(response);
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

  Future<dynamic> referPartnerService(
      String url,
      Map<String, dynamic> requestData,
      String requestType,
      ) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        Utils.printLog("responseData from Service: $response");
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("refer partner add service::::$e");
      throw Exception(e);
    }
  }


  Future<dynamic> businessInfoService(
      String url,
      Map<String, dynamic> requestData,
      String requestType,
      ) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        Utils.printLog("responseData from Service: $response");
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("business information added service::::$e");
      throw Exception(e);
    }
  }

  Future<dynamic> feedbackService(
      String url,
      Map<String, dynamic> requestData,
      String requestType,
      ) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        Utils.printLog("responseData from Service: $response");
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("feedback service::::$e");
      throw Exception(e);
    }
  }

  Future<dynamic> updateSubscriptionPlanService(
      String url,
      Map<String, dynamic> requestData,
      String requestType,
      ) async {
    try {
      print("requestData::::::: $requestData");
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        Utils.printLog("responseData from Service: $response");
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("subscription plan updated service::::$e");
      throw Exception(e);
    }
  }
  Future<CustomerBorrowedData> fetchCustomerBorrowedList(String customerId) async {
    try {
      var api =
          "${NetworkUrls.BASE_URL}${NetworkUrls.CUSTOMER_BORROWED_LIST}$customerId";
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(api);

      if (response != null) {
        return CustomerBorrowedData.fromJson(response);
      } else {
        throw Exception("Unable to fetch container list");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<dynamic> markDamageContainer(Map<String, dynamic> body, File image)async{
    var api =
        "${NetworkUrls.BASE_URL}${NetworkUrls.DAMAGE_CONTAINER}";
    ApiCallPresenter presenter = ApiCallPresenter();
    try{
      var response = presenter.postMultipartRequest(api, image, body, "request", "Post", "images");
      return response;
    }catch (e){throw Exception(e);}
  }

  // Future<ChartModel> fetchChartData(String partUrl) async { TODO KEEP it now for further use
  //   try {
  //     Utils.printLog("requestData::::::: $partUrl");
  //     String url = NetworkUrls.BASE_URL + partUrl;
  //     ApiCallPresenter presenter = ApiCallPresenter();
  //     var response = await presenter.getSSEAPIData(url);
  //     if (response != null) {
  //       Utils.printLog("Chart Response ==== $response");
  //
  //       // Check if response has 'data' wrapper, otherwise use response directly
  //       var chartData;
  //       if (response is Map<String, dynamic>) {
  //         if (response.containsKey('data')) {
  //           chartData = response['data'];
  //           Utils.printLog("Using wrapped data from 'data' key");
  //         } else {
  //           // Response is already the chart data directly
  //           chartData = response;
  //           Utils.printLog("Using response directly as chart data");
  //         }
  //       } else {
  //         chartData = response;
  //       }
  //
  //       Utils.printLog("Chart data to parse: $chartData");
  //       var responseData = ChartModel.fromJson(chartData);
  //       Utils.printLog("✅ responseData in Service: $responseData");
  //       return responseData;
  //     } else {
  //       throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
  //     }
  //   } catch (e) {
  //     Utils.printLog("❌ Get Profile service error::::$e");
  //     throw Exception(e);
  //   }
  // }
  Stream<ChartModel> fetchChartData(String param) {
    final url = NetworkUrls.BASE_URL + param;
    Utils.printLog("service url for chart data: $url");
    final apiService = ApiCallPresenter();

    return apiService.getSSEAPIData(url).map((response) {
        Utils.printLog("Chart Response ==== $response");
      final chartData =
      response.containsKey('data') ? response['data'] : response;

      return ChartModel.fromJson(chartData);
    });
  }

}

final getProfileApiProvider = Provider<ProfileServices>((ref) => ProfileServices());