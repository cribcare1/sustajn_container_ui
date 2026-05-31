import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_customer/profile_screen/history_screen/model/borrowed_data.dart';

import '../constants/network_urls.dart';
import '../network/ApiCallPresentator.dart';
import '../profile_screen/history_screen/model/sold_container_data.dart';
import '../utils/utils.dart';

class HistoryService {
  Future<BorrowedData> borrowedService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = BorrowedData.fromJson(response);
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

  Future<SoldContainerData> getSoldContainerService(String partUrl) async {
    try {
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = SoldContainerData.fromJson(response);
        Utils.printLog("responseData in Service: $responseData");
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
      //TODO
      // String response = await rootBundle.loadString(
      //   'assets/json/sold.json',
      // );
      //
      // print("Raw JSON Response: $response");
      //
      // var jsonData = json.decode(response);
      //
      // print("Decoded JSON: $jsonData");

      // SoldContainerData data =
      // SoldContainerData.fromJson(jsonData);
      //
      // print("Model Response: ${data.toString()}");

      // return data;

    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }
}

final historyServiceProvider = Provider<HistoryService>(
  (ref) => HistoryService(),
);
