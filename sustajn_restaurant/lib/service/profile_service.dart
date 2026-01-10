import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';

import '../constants/network_urls.dart';
import '../network/ApiCallPresentator.dart';
import '../utils/utility.dart';

class ProfileServices {
  Future<dynamic> getProfileService(String url,
      String requestType) async {
    try {
      print("requestData::::::: $requestType");
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
      Utils.printLog("get profile service::::$e");
      throw Exception(e);
    }
  }
}

final getProfileApiProvider = Provider<ProfileServices>((ref) => ProfileServices());