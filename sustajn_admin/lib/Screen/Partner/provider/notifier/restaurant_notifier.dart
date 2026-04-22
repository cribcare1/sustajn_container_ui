import 'package:container_tracking/constants/imports.util.dart';

import '../../model/get_all_restaurant_data.dart';
import '../../model/restaurant_details_data.dart';

class RestaurantListState extends ChangeNotifier{
  BuildContext? _context;
  bool _isLoading = false;
  GetRestaurantData? _getRestaurantData;
  RestaurantDetailsData? _restaurantDtlsData;

  BuildContext get context => _context!;
  bool get isLoading => _isLoading;
  GetRestaurantData? get getRestaurantData => _getRestaurantData;
  RestaurantDetailsData? get restaurantDtlsData => _restaurantDtlsData;

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  void setRestaurantData(GetRestaurantData getRestaurantData){
    _getRestaurantData = getRestaurantData;
    notifyListeners();
  }

  void setRestaurantDtlsData(RestaurantDetailsData restaurantData){
    _restaurantDtlsData = restaurantData;
    notifyListeners();
  }

}