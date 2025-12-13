import 'package:flutter/cupertino.dart';

import 'model/customer_list_model.dart';

class CustomerState extends ChangeNotifier {
  bool _isLoading = false;
  bool _isMoreLoading = false;
  bool _hasMore = true;
  int _size = 10;
  int _page = 0;
  List<CustomerData> _customerList = [];
  String _error = "";
  BuildContext? _context;

  List<CustomerData> get customerList => _customerList;

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
  void setCustomer(List<CustomerData> data) {
    _customerList = data;
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
  // void resetPagination() {
  //   _page = 0;
  //   _hasMore = true;
  //   _customerList.clear();
  //   notifyListeners();
  // }

  void incrementPage() {
    _page++;
  }
  // void addCustomers(List<CustomerData> data) {
  //   if (data.length < _size) {
  //     _hasMore = false;
  //   }
  //   _customerList.addAll(data);
  //   notifyListeners();
  // }
}
