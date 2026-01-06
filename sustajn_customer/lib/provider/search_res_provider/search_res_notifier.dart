import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../../models/resturant_address_model.dart';

class SearchResState extends ChangeNotifier{
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  BuildContext? _context;
  BuildContext? get context => _context;
  List<SearchData> _resList = [];
  List<SearchData> get resList => _resList ;
  String _error = "";
  String get error => _error;
  void setLoading(bool isLoadingData){
    _isLoading = isLoadingData;
    notifyListeners();
  }
  void setContext(BuildContext context){
    _context = context;
    notifyListeners();
  }
  void setRestaurant(List<SearchData> data){
    _resList = data;
    notifyListeners();
  }
  void setError(String error){
    _error = error;
    notifyListeners();
  }
}