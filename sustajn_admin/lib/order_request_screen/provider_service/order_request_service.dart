import 'package:container_tracking/order_request_screen/models/deliver_order_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/network_urls.dart';
import '../../network/ApiCallPresentor.dart';
import '../../utils/utility.dart';
import '../models/confirm_model.dart';
import '../models/pending_model.dart';
import '../models/reject_order_model.dart';

class OrderRequestServices {

  Future<PendingData> getPendingOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = PendingData.fromJson(response);
        Utils.printLog("User responseData in Service: ${responseData.status}");

        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Profile service::::$e");
      throw Exception(e);
    }
  }
  Future<ConfirmData> getConfirmOrderService(String partUrl) async {
      try {
        Utils.printLog("requestData::::::: $partUrl");
        String url = NetworkUrls.BASE_URL + partUrl;
        ApiCallPresenter presenter = ApiCallPresenter();
        var response = await presenter.getAPIData(url);
        if (response != null) {
          var responseData = ConfirmData.fromJson(response);
          Utils.printLog("User responseData in Service: ${responseData.status}");

          return responseData;
        } else {
          throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
        }
      } catch (e) {
        Utils.printLog("Get Profile service::::$e");
        throw Exception(e);
      }
    }

  Future<DeliverData> getDeliverOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = DeliverData.fromJson(response);
        Utils.printLog("User responseData in Service: ${responseData.status}");

        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Profile service::::$e");
      throw Exception(e);
    }
  }

  Future<RejectOrderData> getRejectOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = RejectOrderData.fromJson(response);
        Utils.printLog("User responseData in Service: ${responseData.status}");

        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Profile service::::$e");
      throw Exception(e);
    }
  }
}

final orderRequestServices = Provider<OrderRequestServices>((ref) => OrderRequestServices());