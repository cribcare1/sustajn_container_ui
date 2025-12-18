import 'dart:io';

import 'package:container_tracking/network/ApiCallPresentor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/network_urls.dart';
import '../utils/utility.dart';
import 'model/container_list_model.dart';

class ContainerService {
  Future<dynamic> addContainer(String url, Map<String, dynamic> requestData, String requestType, File? file) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postMultipartRequestAdmin(url,file, requestData,"",requestType);
      if (response != null) {
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      Utils.printLog("container add service::::$e");
      throw Exception(e);
    }
  }
  Future<dynamic> fetchContainer(String url) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = ContainerListModel.fromJson(response);
        return responseData;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      throw Exception(e);
    }
  }
  Future<dynamic> deleteContainer(String url) async {
    try {
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.postApiData(url,{},"Post");
      if (response != null) {
        return response;
      } else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){
      Utils.printLog("container add service::::$e");
      throw Exception(e);
    }
  }
}




final containerApiProvider = Provider<ContainerService>((ref) => ContainerService());