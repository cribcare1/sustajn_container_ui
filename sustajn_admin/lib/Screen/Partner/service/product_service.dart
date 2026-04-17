import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/network_urls.dart';
import '../../../network/ApiCallPresentor.dart';
import '../../../utils/utility.dart';
import '../model/container_history_data.dart';
import '../model/get_container_data.dart';

class OrderServices {

  Future<GetContainerData> getOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = GetContainerData.fromJson(response);
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



  Future<ContainerHistoryData> getContaineHistoryService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = ContainerHistoryData.fromJson(response);
        Utils.printLog("responseData in Service: ${responseData.toJson()}");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Container History service::::$e");
      throw Exception(e);
    }
  }


  Future<ContainerHistoryData> returnedContainerService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = ContainerHistoryData.fromJson(response);
        Utils.printLog("responseData in Service: ${responseData.toJson()}");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Container History service::::$e");
      throw Exception(e);
    }
  }

}

final getOrderApiProvider = Provider<OrderServices>((ref) => OrderServices());
