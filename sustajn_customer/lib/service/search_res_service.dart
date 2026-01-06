import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/network_urls.dart';
import '../models/resturant_address_model.dart';
import '../network/ApiCallPresentator.dart';
class SearchResService{
  Future<List<SearchData>?> searchRestaurant(Map<String, dynamic> body)async{

    var api = "${NetworkUrls.BASE_URL}${NetworkUrls.SEARCH_RESTAURANT}?keyword=${body['keyword']}&lat=${body['lat']}&lon=${body['lon']}";
    try{
      ApiCallPresenter presenter = ApiCallPresenter();
      var response = await presenter.getAPIData(api);
      if(response != null){
        final List list = response['searchData'] ?? [];
        return list
            .map((e) => SearchData.fromJson(e))
            .toList();
      }else{
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }
    }catch(e){throw Exception(e);}
  }
}

final searchRestaurantService = Provider<SearchResService>((res) => SearchResService());