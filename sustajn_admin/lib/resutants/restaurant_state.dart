import 'package:flutter/cupertino.dart';

import 'models/restaurant_list_model.dart';

class RestaurantState extends ChangeNotifier {
  RestaurantState(){
    _isLoading = true;
  }
  bool _isLoading = false;
  bool _isMoreLoading = false;
  bool _hasMore = true;
  int _size = 10;
  int _page = 0;
  List<RestaurantData> _restaurantList = [];
  String _error = "";
  BuildContext? _context;

  List<RestaurantData> get restaurantList => _restaurantList;

  int get page => _page;

  int get size => _size;

  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  bool get hasMore => _hasMore;
  String get error => _error;

  BuildContext? get context => _context;

  void setLoading(bool l) {
    _isLoading = l;
    notifyListeners();
  }
  void setMoreLoading(bool value) {
    _isMoreLoading = value;
    notifyListeners();
  }
  void setSize(int size) {
    _size = size;
    notifyListeners();
  }

  void setPage(int p) {
    _page = p;
    notifyListeners();
  }

  void setRestaurant(List<RestaurantData> data) {
    _restaurantList = data;
    notifyListeners();
  }

  void setError(String e) {
    _error = e;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }
  void resetPagination() {
    _page = 0;
    _hasMore = true;
    _restaurantList.clear();
    notifyListeners();
  }

  void incrementPage() {
    _page++;
  }
  void addRestaurants(List<RestaurantData> data) {
    if (data.length < _size) {
      _hasMore = false;
    }
    _restaurantList.addAll(data);
    notifyListeners();
  }
}
