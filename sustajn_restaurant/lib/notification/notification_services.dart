import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/constants/network_urls.dart';
import 'package:sustajn_restaurant/network/ApiCallPresentator.dart';

class NotificationServices {
  ApiCallPresenter presenter = ApiCallPresenter();
  Future<dynamic> fetchAllNotification(int userId)async{
    var api = "${NetworkUrls.BASE_URL}${NetworkUrls.GET_ALL_NOTIFICATION}$userId";
    try{
      var response = await presenter.getAPIData(api);
      if(response != null){
        return response;
      }else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }

    }catch(e){
      throw Exception(e.toString());
    }
  }

  Future<dynamic> fetchNotificationCount(int userId)async{
    var api = "${NetworkUrls.BASE_URL}${NetworkUrls.GET_NOTIFICATION_COUNT}$userId";
    try{
      var response = await presenter.getAPIData(api);
      if(response != null){
        return response;
      }else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }

    }catch(e){
      throw Exception(e.toString());
    }
  }
  Future<dynamic> markAsRead(int userId, int notificationId)async{
    var api = "${NetworkUrls.BASE_URL}${NetworkUrls.MARK_READ}$notificationId ?receiverId=$userId";
    try{
      var response = await presenter.postApiData(api,{},"");
      if(response != null){
        return response;
      }else {
        throw Exception(NetworkUrls.EMPTY_RESPONSE_CODE);
      }

    }catch(e){
      throw Exception(e.toString());
    }
  }

}

final notificationServiceProvider = Provider<NotificationServices>((ref) => NotificationServices());