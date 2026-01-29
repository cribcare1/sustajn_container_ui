import 'package:flutter/material.dart';

import '../models/product_data.dart';
import '../utils/utils.dart';

class ProductNotifier extends ChangeNotifier {
  bool _isLoading = false;
  BuildContext? _context;

  ProductData? _productData;

  List<Data> _productList = [];

  bool get isLoading => _isLoading;

  BuildContext get context => _context!;

  ProductData get productData => _productData!;

  List<Data> get productList => _productList;

  void setProductData(ProductData data) {
    _productData = data;
    _productList = data.data!;
    notifyListeners();
  }

  void clearProductList() {
    _productList.clear();
    Utils.printLog('pending vehicle List cleared');
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }
}
