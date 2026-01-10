import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/constants/network_urls.dart';
import 'package:sustajn_restaurant/network/ApiCallPresentator.dart';
import 'package:sustajn_restaurant/search_screen/search_restaurant_model.dart';
class SearchRestaurantService{
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

final searchRestaurantService = Provider<SearchRestaurantService>((res) => SearchRestaurantService());