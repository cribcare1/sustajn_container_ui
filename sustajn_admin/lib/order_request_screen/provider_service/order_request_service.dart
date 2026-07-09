import 'package:container_tracking/order_request_screen/models/approve_order_data.dart';
import 'package:container_tracking/order_request_screen/models/deliver_data.dart';
import 'package:container_tracking/order_request_screen/models/deliver_order_model.dart';
import 'package:container_tracking/order_request_screen/models/reject_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/network_urls.dart';
import '../../network/ApiCallPresentor.dart';
import '../../utils/utility.dart';
import '../models/confirm_detail_data.dart';
import '../models/confirm_model.dart';
import '../models/deliver_details_data.dart';
import '../models/pending_detail_data.dart';
import '../models/pending_model.dart';
import '../models/reject_detail_data.dart';
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

  Future<PendingDetailsData> getPendingDetailOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = PendingDetailsData.fromJson(response);
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

  Future<ConfirmDetailsData> getConfirmDetailOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = ConfirmDetailsData.fromJson(response);
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

  Future<DeliverDetailData> getDeliverDetailOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = DeliverDetailData.fromJson(response);
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

  Future<RejectDetailsData> getRejectDetailOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = RejectDetailsData.fromJson(response);
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

//Approve Order Service

  Future<ApproveOrder> getApproveOrderService(String partUrl, Map<String, dynamic> requestData) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        var responseData = ApproveOrder.fromJson(response);
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

  //Reject Service
  Future<RejectData> getRejectedOrderService(String partUrl, Map<String, dynamic> requestData) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, requestData);
      if (response != null) {
        var responseData = RejectData.fromJson(response);
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

  //Mark as Delivered Service
  Future<DeliversData> getMarkDeliverOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiRequest(url, new Map());
      if (response != null) {
        var responseData = DeliversData.fromJson(response);
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