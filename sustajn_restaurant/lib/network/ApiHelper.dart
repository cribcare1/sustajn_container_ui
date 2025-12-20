import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../utils/utility.dart';

class ApiHelper {

  Future apiRequest(String url) async {
    final token = Utils.authToken();
    Utils.printLog("Get call url::$url");
    Utils.printLog("Get token::$token");
    http.Response? response;
    try {
      var header = _getHeader(token);
      Utils.printLog("Get header :: $header");
      response = await http.get(Uri.parse(url),
          headers: header).timeout(const Duration(seconds: 20),);
      Utils.printLog("Network call success. response==${response.statusCode}");
      return response;
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response(Strings.ERROR, NetworkUrls.TIME_OUT_CODE);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==$excetion");
      return http.Response(Strings.ERROR, NetworkUrls.NETWORK_CALL_FAILED_CODE);
    }
  }

  _getHeader(var token){
    return (token != null && token.toString().isNotEmpty)?{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token', // Add token to the headers
    }:{
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
  }

  Future<http.Response> apiPostRequest(String url, dynamic jsonMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print("User Token $token");

    print("call started==url==$url");
    var response;

    try {
      // Check if jsonMap is a List<Map<String, dynamic>>
      if (jsonMap is List<Map<String, dynamic>>) {
        var body = json.encode(jsonMap);
        print("List body====$body");

        if (token != null) {
          response = await http.post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token', // Add token to the headers
              },
              body: body);
        } else {
          response = await http.post(Uri.parse(url), body: body);
          // throw Exception("Token not found");
        }
      } else if (jsonMap is Map<String, dynamic>) {
        // If jsonMap is a Map<String, dynamic>
        var body = json.encode(jsonMap);
        print("Map body====$body");

        // Check if token is available
        if (token != null) {
          response = await http.post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token', // Add token to the headers
              },
              body: body);
        } else {
          response = await http.post(Uri.parse(url), body: body);
          // throw Exception("Token not found");
        }
      } else {
        throw Exception(
            "Invalid jsonMap type. Expected List<Map<String, dynamic>> or Map<String, dynamic>.");
      }

      print("Network call success. response==${response.statusCode}");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }

    return response;
  }

  /// @param url, jsonmap
  ///       After getting url ,it will make actual call to api  by POST mapping
  /// @return  future response
  ///        the respone body of the api it will return
  ///

  Future<dynamic> apiPostLoginRequest(String url, var jsonMap) async {
    Utils.printLog("Post call started==url==$url");
    var token = Utils.authToken();
    Utils.printLog('Token : $token');
    http.Response? response;
    try {
      var body = json.encode(jsonMap);
      Utils.printLog("body====$body");
      response = await http.post(Uri.parse(url),
          headers: _getHeader(token), body: body).timeout(const Duration(seconds: 10),);
      Utils.printLog("Network call success. response==${response.statusCode}");
      return response;
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response(Strings.ERROR, NetworkUrls.TIME_OUT_CODE);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==$excetion");
      return http.Response(Strings.ERROR, NetworkUrls.NETWORK_CALL_FAILED_CODE);
    }
  }

  Future apiMultiPartPostRequests(String url, Map<String, dynamic> jsonMap, image, String keyName) async {
    final token = Utils.authToken();
    Utils.printLog("Get call started==url==$url");
    http.Response? responseData;
    try {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();

      var body = json.encode(jsonMap);

      Utils.printLog("body====$body");
      Utils.printLog("keyName====$keyName");
      Utils.printLog("call started==url==$url");

      var request = http.MultipartRequest("POST", Uri.parse(url),);
      request.headers['Content-Type'] = 'multipart/form-data';
      if(token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token'; // Add token to headers
      }

      request.fields[keyName] = jsonEncode(jsonMap);

      var multiPart = http.MultipartFile('file', stream, length,
        filename: image.path.split('/').last,
      );
      request.files.add(multiPart);
      final response = await request.send().timeout(const Duration(seconds: 30));
      final responseJson = await response.stream.bytesToString();
      responseData = http.Response(responseJson, response.statusCode);
      print("Network call success. response==${responseData.statusCode}");
      return responseData;
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response(Strings.ERROR, NetworkUrls.TIME_OUT_CODE);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==$excetion");
      return http.Response(Strings.ERROR, NetworkUrls.NETWORK_CALL_FAILED_CODE);
    }

  }


  Future<http.Response> apiMultiPartPostRequest(
      String url, Map<String, dynamic> jsonMap, var image, String keyName) async {

    final token = Utils.authToken();
    Utils.printLog("Multipart call started==url==$url");

    http.Response? responseData;
    try {

      var body = json.encode(jsonMap);
      Utils.printLog("body====$body");
      Utils.printLog("keyName====$keyName");
      Utils.printLog("token::$token");

      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers['Content-Type'] = 'multipart/form-data';
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields[keyName] = jsonEncode(jsonMap);
      if(image != null) {
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();
        var multiport = http.MultipartFile(
          'file',
          stream,
          length,
          filename: image.path.split('/').last,
        );
        request.files.add(multiport);
      }


      final response = await request.send().timeout(const Duration(seconds: 30));
      final responseJson = await response.stream.bytesToString();
      responseData = http.Response(responseJson, response.statusCode);

      Utils.printLog("Network call success. response==${responseData.statusCode}");

      if (responseData.statusCode == 408) {
        // Optionally log or handle the specific status code
        Utils.printLog('408 error: Request timed out at server');
      }

      return responseData;
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out in apiMultiPartPostRequest');
      return http.Response('Request timed out', 408);
    } catch (exception) {
      Utils.printLog("Network call failed, exception==$exception");
      return http.Response('Network call failed', 500);
    }
  }


  Future<http.Response> apiMultipartRequest(
      String url, Map<String, dynamic> jsonMap, var image, String keyName, var document) async {

    final token = Utils.authToken();
    Utils.printLog("Multipart call started==url==$url");

    http.Response? responseData;
    try {
      var body = json.encode(jsonMap);
      Utils.printLog("body====$body");
      Utils.printLog("keyName====$keyName");
      Utils.printLog("token::$token");

      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers['Content-Type'] = 'multipart/form-data';
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add JSON map as a field
      request.fields[keyName] = jsonEncode(jsonMap);

      // Add image file if provided
      if (image != null) {
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();
        var multiport = http.MultipartFile('file', stream, length,
            filename: image.path.split('/').last);
        request.files.add(multiport);
      }

      if (document != null) {
        var stream = http.ByteStream(document.openRead());
        var length = await document.length();
        var multiport = http.MultipartFile('document', stream, length,
            filename: document.path.split('/').last);
        request.files.add(multiport);
      }

      final response = await request.send().timeout(const Duration(seconds: 30));
      final responseJson = await response.stream.bytesToString();
      responseData = http.Response(responseJson, response.statusCode);

      Utils.printLog("Network call success. response==${responseData.statusCode}");

      if (responseData.statusCode == 408) {
        Utils.printLog('408 error: Request timed out at server');
      }

      return responseData;
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out in apiMultiPartPostRequest');
      return http.Response('Request timed out', 408);
    } catch (exception) {
      Utils.printLog("Network call failed, exception==$exception");
      return http.Response('Network call failed', 500);
    }
  }



  Future<http.Response> apiPutRequest(String url, data) async {
    const token = "Utils.token";
    Utils.printLog("call put==url==$url");

    http.Response response;
    try {
      var body = json.encode(data);
      response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      print("Network call success. response==${response.statusCode}");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==$excetion");
      return http.Response('Error', 409);
    }
    return response;
  }


  Future<http.Response> apiMultiPartListFilePostRequest(
      String url, Map<String, dynamic> jsonMap, var imageList, String keyName) async {
    Utils.printLog("Image File length: ${imageList.length}");
    final token = Utils.authToken();
    Utils.printLog("MultipartPost call started==url==$url");
    Utils.printLog("token: $token");
    http.Response? responseData;
    try {
      var body = json.encode(jsonMap);
      Utils.printLog("body====$body");
      Utils.printLog("keyName====$keyName");

      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers['Content-Type'] = 'multipart/form-data';
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      request.fields[keyName] = jsonEncode(jsonMap);
      for(File image in imageList){
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();
        var fileName = path.basename(image.path);
        var multiport = http.
        MultipartFile('files', stream, length,
            filename: image.path
                .split('/')
                .last);
        request.files.add(multiport);
      }

      final response = await request.send().timeout(const Duration(seconds: 30));
      final responseJson = await response.stream.bytesToString();
      responseData = http.Response(responseJson, response.statusCode);

      Utils.printLog("Network call success. response==${responseData.statusCode}");

      if (responseData.statusCode == 408) {
        // Optionally log or handle the specific status code
        Utils.printLog('408 error: Request timed out at server');
      }

      return responseData;
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out in apiMultiPartPostRequest');
      return http.Response('Request timed out', 408);
    } catch (exception) {
      Utils.printLog("Network call failed, exception==$exception");
      return http.Response('Network call failed', 500);
    }
  }

  Future<http.Response> saveOrUpdateContainerType({
    required String url,
    required Map<String, dynamic> requestJson,
    File? file,
  }) async {
    final token = Utils.authToken();
    Utils.printLog("Multipart call started => URL: $url");

    try {
      var multipartRequest = http.MultipartRequest("POST", Uri.parse(url));

      // Set headers
      // multipartRequest.headers['Content-Type'] = 'multipart/form-data';
      if (token.isNotEmpty) {
        multipartRequest.headers['Authorization'] = 'Bearer $token';
      }

      // Add JSON as string field -> "request"
      multipartRequest.fields["data"] = jsonEncode(requestJson);

      // Add file if exists
      if (file != null) {
        // var stream = http.ByteStream(file.openRead());
        // var length = await file.length();
        // var multipartFile = http.MultipartFile(
        //   'profileImage', file.path, length,
        //   filename: file.path.split('/').last,
        // );
        final fileName = file.path.split('/').last;

        multipartRequest.files.add( await http.MultipartFile.fromPath(
          'profileImage',
          file.path,
          filename: fileName,
          contentType: http.MediaType('image', 'jpeg'), // or png
        ),);
      }

      // Send request
      final streamedResponse = await multipartRequest
          .send()
          .timeout(const Duration(seconds: 30));

      // Convert stream to normal Response
      final responseString = await streamedResponse.stream.bytesToString();
      Utils.printLog("Status Code => ${streamedResponse.statusCode}");
      Utils.printLog("Response => $responseString");

      return http.Response(responseString, streamedResponse.statusCode);

    } on TimeoutException {
      Utils.printLog("⛔ Timeout Exception");
      return http.Response("Request timed out", 408);
    } catch (e) {
      Utils.printLog("⛔ Error => $e");
      return http.Response("Network call failed", 500);
    }
  }
}