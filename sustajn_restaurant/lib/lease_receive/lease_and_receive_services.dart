import 'package:sustajn_restaurant/constants/network_urls.dart';
import 'package:sustajn_restaurant/network/ApiCallPresentator.dart';

import 'model/container_list_model.dart';

Future<dynamic> sendLease(Map<String,dynamic> body)async{}
Future<dynamic> takeReturn(Map<String,dynamic> body)async{}
Future<ContainerListModel> fetchContainerList(String restaurantId)async{
  try{
    var api = "${NetworkUrls.BASE_URL}${NetworkUrls.CONTAINER_LIST_LEASE}$restaurantId";
    ApiCallPresenter presenter = ApiCallPresenter();
    var response = await presenter.getAPIData(api);
    if(response != null){
      return ContainerListModel.fromJson(response);
    }else{
      throw Exception("Unable to fetch container list");
    }

  }catch(e){
    throw Exception(e);
  }
}