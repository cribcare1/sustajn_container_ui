import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/constants/network_urls.dart';
import 'package:sustajn_restaurant/network/ApiCallPresentator.dart';

import 'model/container_list_model.dart';
import 'model/container_return_list_model.dart';
class LeaseAndReceiveServices {
  ApiCallPresenter presenter = ApiCallPresenter();
  Future<dynamic> leaseContainer(Map<String,dynamic> body)async{
    var api = "${NetworkUrls.BASE_URL}${NetworkUrls.CONTAINER_LEASE}";
    try{
      var response = await presenter.postApiStringData(api, body,"");
      if(response != null){
        return response;
      }else{
        throw Exception("Something went wrong");
      }
    }catch(e){
      throw Exception(e);
    }
  }
  Future<dynamic> receiveContainer(Map<String,dynamic> body)async{
    var api = "${NetworkUrls.BASE_URL}${NetworkUrls.CONTAINER_RECEIVE}";
    try{
      var response = await presenter.postApiData(api, body, "");
      if(response != null){
        return response;
      }else{
        throw Exception("Something went wrong");
      }
    }catch(e){
      throw Exception(e);
    }
  }
  Future<ContainerListModel> fetchContainerList(String restaurantId)async{
    try{
      var api = "${NetworkUrls.BASE_URL}${NetworkUrls.CONTAINER_LIST_LEASE}$restaurantId";
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
  Future<CustomerBorrowedData> fetchCustomerBorrowedList(String customerId) async {
    try {
      var api =
          "${NetworkUrls.BASE_URL}${NetworkUrls.CUSTOMER_BORROWED_LIST}$customerId";

      var response = await presenter.getAPIData(api);

      if (response != null) {
        return CustomerBorrowedData.fromJson(response);
      } else {
        throw Exception("Unable to fetch container list");
      }
    } catch (e) {
      throw Exception(e);
    }
  }

}

final leaseAPIServices = Provider<LeaseAndReceiveServices>((ref) =>LeaseAndReceiveServices());