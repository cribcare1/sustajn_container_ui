import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../utils/utility.dart';
import 'AppDataManager.dart';
import 'api_data_listener.dart';
import 'base_presentator.dart';


class ApiCallPresenter extends BasePresentor<ApiDataListener>{

  Future<dynamic> getAPIData(String url) async {
    var response = await appDataManager.apiHelper.apiRequest(url);
    if (Utils.isReqSuccess(response)) {
      try {
        final jsonData = json.decode(response.body);
        Utils.printLog('Response status: $jsonData');
        return jsonData;
      } catch (e) {
        Utils.printLog('Error decoding JSON: $e');
        throw Exception('Error decoding JSON: $e');
      }
    } else {
      Utils.printLog('Error response status code: ${response.statusCode}');
      throw Exception('Error: ${response.statusCode}');
    }
  }




  Future<dynamic> postMultipartRequest(String url, File image, Map<String, dynamic> jsonMap, String keyName, String responseType,) async {
    try {
      var response = await appDataManager.apiHelper.apiMultiPartPostRequest(url, jsonMap, image, keyName);

      if (Utils.isReqSuccess(response)) {
        try {
          final jsonData = json.decode(response.body);
          Utils.printLog('Response status: $jsonData');
          return jsonData;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          throw Exception('Error decoding JSON: $e');
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        throw Exception('Error: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      Utils.printLog('Timeout occurred in postMultipartRequest');
      throw Exception('Request timed out'); // Handle timeout specifically
    } catch (e) {
      Utils.printLog('Unhandled exception in postMultipartRequest: $e');
      throw Exception('An error occurred: $e'); // Handle other exceptions
    }
  }


  Future<dynamic> postLoginRequest_old(
      String url, Map<String, dynamic> data) async {
    final response = await appDataManager.apiHelper.apiPostLoginRequest(url, data);
    Utils.printLog(
        "response code == ${response.statusCode} response == ${response.body}");
    if (Utils.isReqSuccess(response)) {
      try {
        final jsonData = json.decode(response.body);
        Utils.printLog('Response status: $jsonData');
        return jsonData;
      } catch (e) {
        Utils.printLog('Error decoding JSON: $e');
        throw Exception('Error decoding JSON: $e');
      }
    } else {
      Utils.printLog('Error response status code: ${response.statusCode}');
      Utils.printLog('Error response body: ${response.body}');
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<dynamic> postApiData(String url, var jsonMap, String requestType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response;

    try {
      response = await appDataManager.apiHelper.apiPostLoginRequest(url, jsonMap);
      if (response != null && Utils.isReqSuccess(response)) {
        Utils.printLog("response code == ${response.statusCode}  response == ${response.toString()}");
        var jsonData = await json.decode(response.body);

        Utils.printLog('Response status: $jsonData');
        isViewAttached ? getView().onSuccess(jsonData, requestType) : null;
      } else {
        Utils.printLog('Null response received');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } catch (e) {
      Utils.printLog('Error: $e');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
  }


  Future<dynamic> putMultipartApiRequest(
      String url, Map<String, dynamic> data, keyName, file) async {
    try {
      var response = await appDataManager.apiHelper.apiMultiPartPostRequest(url, data, file, keyName);

      if (Utils.isReqSuccess(response)) {
        try {
          final jsonData = json.decode(response.body);
          Utils.printLog('Response status: $jsonData');
          return jsonData;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          throw Exception('Error decoding JSON: $e');
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        throw Exception('Error: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      Utils.printLog('Timeout occurred in postMultipartRequest');
      throw Exception('Request timed out'); // Handle timeout specifically
    } catch (e) {
      Utils.printLog('Unhandled exception in postMultipartRequest: $e');
      throw Exception('An error occurred: $e'); // Handle other exceptions
    }
  }

  Future<dynamic> putMultipartDocument(
      String url, Map<String, dynamic> data, keyName, file, document) async {
    try {
      var response = await appDataManager.apiHelper.apiMultipartRequest(url, data, file, keyName, document);

      if (Utils.isReqSuccess(response)) {
        try {
          final jsonData = json.decode(response.body);
          Utils.printLog('Response status: $jsonData');
          return jsonData;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          throw Exception('Error decoding JSON: $e');
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        throw Exception('Error: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      Utils.printLog('Timeout occurred in putMultipartDocument');
      throw Exception('Request timed out'); // Handle timeout specifically
    } catch (e) {
      Utils.printLog('Unhandled exception in putMultipartDocument : $e');
      throw Exception('An error occurred: $e'); // Handle other exceptions
    }
  }



  Future<dynamic> postMultipartFileListApiRequest(
      String url, Map<String, dynamic> data, keyName, file) async {
    try {
      var response = await appDataManager.apiHelper.apiMultiPartListFilePostRequest(url, data, file, keyName);
      Utils.printLog("Image File list: ${file.length}");
      if (Utils.isReqSuccess(response)) {
        try {
          final jsonData = json.decode(response.body);
          Utils.printLog('Response status: $jsonData');
          return jsonData;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          throw Exception('Error decoding JSON: $e');
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        throw Exception('Error: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      Utils.printLog('Timeout occurred in postMultipartRequest');
      throw Exception('Request timed out'); // Handle timeout specifically
    } catch (e) {
      Utils.printLog('Unhandled exception in postMultipartRequest: $e');
      throw Exception('An error occurred: $e'); // Handle other exceptions
    }
  }

  Future<dynamic> postMultipartRequestAdmin(String url, File image, Map<String, dynamic> jsonMap, String keyName, String responseType,) async {
    try {
      var response = await appDataManager.apiHelper.saveOrUpdateContainerType( url: url, requestJson: jsonMap,file: image);

      if (Utils.isReqSuccess(response)) {
        try {
          final jsonData = json.decode(response.body);
          Utils.printLog('Response status: $jsonData');
          return jsonData;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          throw Exception('Error decoding JSON: $e');
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        throw Exception('Error: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      Utils.printLog('Timeout occurred in postMultipartRequest');
      throw Exception('Request timed out'); // Handle timeout specifically
    } catch (e) {
      Utils.printLog('Unhandled exception in postMultipartRequest: $e');
      throw Exception('An error occurred: $e'); // Handle other exceptions
    }
  }


}