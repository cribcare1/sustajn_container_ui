import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/network_urls.dart';
import '../network/ApiCallPresentor.dart';
import '../product_screen/inventory_detail_screens/models/issuedtopartner_model.dart';
import '../product_screen/inventory_detail_screens/models/ordered_data_model.dart';
import '../product_screen/inventory_detail_screens/models/partner_sold_model.dart';
import '../product_screen/inventory_detail_screens/models/return_model.dart';
import '../product_screen/inventory_detail_screens/models/user_sold_model.dart';
import '../product_screen/models/damage_data.dart';
import '../product_screen/models/incirculation_data.dart';
import '../product_screen/models/incirculation_detail_data.dart';
import '../product_screen/models/inventory_details_data.dart';
import '../product_screen/models/inventory_order_data.dart';
import '../product_screen/models/with_partner_data.dart';
import '../product_screen/models/withpartner_detail_data.dart';
import '../resutants/models/get_container_data.dart';
import '../utils/utility.dart';

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

  Future<Map<String, dynamic>> fetchContainerCount(
    int restaurantId,
    int productId,
  ) async {
    try {
      String url =
          "${NetworkUrls.BASE_URL + NetworkUrls.CONTAINER_COUNT}?restaurantId=$restaurantId&productId=$productId";
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Profile service::::$e");
      throw Exception(e);
    }
  }

  //InCirculation Order Service
  Future<InCirculationData> getInCirculationOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = InCirculationData.fromJson(response);
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

  //With Partner Order Service
  Future<WithPartnerData> getWithPartnerOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = WithPartnerData.fromJson(response);
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

  //Damaged order service
  Future<DamagedContainerData> getDamagedOrderService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = DamagedContainerData.fromJson(response);
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

  //Sold order service
  // Future<SoldContainersData> getSoldOrderService(String partUrl) async {
  //   try {
  //     Utils.printLog("requestData::::::: $partUrl");
  //     String url = NetworkUrls.BASE_URL + partUrl;
  //     ApiCallPresenter presenter = ApiCallPresenter();
  //     var response = await presenter.getAPIData(url);
  //     if (response != null) {
  //       var responseData = SoldContainersData.fromJson(response);
  //       Utils.printLog("responseData in Service: $responseData");
  //       return responseData;
  //     } else {
  //       throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
  //     }
  //   } catch (e) {
  //     Utils.printLog("Get Profile service::::$e");
  //     throw Exception(e);
  //   }
  // }
  ///IncirculationList order Service
  Future<IncirculationDetailsData> getInCirculationListOrderService(
    String partUrl,
  ) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = IncirculationDetailsData.fromJson(response);
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

  ///WithPartner Detail order service

  Future<WithPartnerDetailsData> getWithPartnerDetailOrderService(
    String partUrl,
  ) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = WithPartnerDetailsData.fromJson(response);
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

  ///Inventory Detail Order Service
  Future<InventoryDetailsData> getInventoryOrdersService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = InventoryDetailsData.fromJson(response);
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

  ///Inventory Order Service
  Future<InventoryOrderData> getInventoryOrderedService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = InventoryOrderData.fromJson(response);
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

  /// Inventory OrderDetails Service
  Future<List<OrderedData>> getOrderDetailsService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");

      String url = NetworkUrls.BASE_URL + partUrl;

      ApiCallPresenter presenter = ApiCallPresenter();

      var response = await presenter.getAPIData(url);

      if (response != null) {
        List<OrderedData> responseData =
        (response as List)
            .map((e) => OrderedData.fromJson(e))
            .toList();

        Utils.printLog("responseData length = ${responseData.length}");

        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    } catch (e) {
      Utils.printLog("Get Order service:::: $e");
      throw Exception(e);
    }
  }

  ///Issued to Partner service
  Future<List<IssuedToPartnerData>> getIssuedToPartnerOrdersService(
      String partUrl) async {

    try {

      Utils.printLog("requestData::::::: $partUrl");

      String url = NetworkUrls.BASE_URL + partUrl;

      ApiCallPresenter presenter = ApiCallPresenter();

      var response = await presenter.getAPIData(url);


      if (response != null) {

        List<IssuedToPartnerData> responseData = [];

        for (var item in response) {
          responseData.add(
            IssuedToPartnerData.fromJson(item),
          );
        }


        Utils.printLog(
            "responseData length: ${responseData.length}"
        );

        return responseData;

      } else {

        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);

      }

    } catch (e) {

      Utils.printLog(
        "Issued Partner service error::::$e",
      );

      throw Exception(e);

    }
  }

  ///Inventory UserSold order service

  Future<UserSoldData> getUserOrderedService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = UserSoldData.fromJson(response);
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

  ///Inventory PartnerSold order service

  Future<PartnerSoldData> getPartnerOrderedService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = PartnerSoldData.fromJson(response);
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
  ///Inventory Returned order service
  Future<ReturnedData> getReturnOrderedService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = ReturnedData.fromJson(response);
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
}

final getOrderApiProvider = Provider<OrderServices>((ref) => OrderServices());
