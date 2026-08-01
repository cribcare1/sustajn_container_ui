import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../Screen/users/model/user_sold_container_data.dart';
import '../../constants/network_urls.dart';
import '../../network/ApiCallPresentor.dart';
import '../../order_request_screen/models/pending_model.dart';
import '../../utils/utility.dart';
import '../models/damage_partner_data.dart';
import '../models/damage_user_data.dart';

class DamageServices {

  Future<DamageUserData> getDamageUserService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = DamageUserData.fromJson(response);
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

  Future<DamagePartnerData> getDamagePartnerService(String partUrl) async {
    try {
      Utils.printLog("requestData::::::: $partUrl");
      String url = NetworkUrls.BASE_URL + partUrl;
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(url);
      if (response != null) {
        var responseData = DamagePartnerData.fromJson(response);
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

final damageServices = Provider<DamageServices>((ref) => DamageServices());