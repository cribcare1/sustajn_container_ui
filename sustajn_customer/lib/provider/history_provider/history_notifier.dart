import 'package:flutter/material.dart';

import '../../profile_screen/history_screen/model/borrowed_data.dart';
import '../../profile_screen/history_screen/model/borrowed_items.dart';
import '../../utils/utils.dart';

class HistoryNotifier extends ChangeNotifier {
  bool _isLoading = false;
  BuildContext? _context;

  BorrowedData? _borrowedData;


  List<BorrowedUiItem> _borrowedList = [];


  bool get isLoading => _isLoading;

  BuildContext get context => _context!;

  List<BorrowedUiItem> get borrowedList => _borrowedList;

  void setBorrowedData(BorrowedData data) {
    _borrowedList = [];

    final decemberList = data.value?.december;

    if (decemberList != null) {
      for (final order in decemberList) {
        final restaurantName = order.restaurantName ?? '';
        final restaurantAddress = order.restaurantAddress ?? '';
        final date = order.orderDate ?? '';
        final time = order.orderTime ?? '';

        final products = order.productOrderListResponseList ?? [];

        for (final product in products) {
          _borrowedList.add(
            BorrowedUiItem(
              restaurantName: restaurantName,
              resturantAddress: restaurantAddress,
              productName: product.productName ?? '',
              capacity: product.capacity ?? 0,
              containerCount: product.containerCount ?? 0,
              productId: product.productUniqueId ??'',
              date: date,
              time: time,
              imageUrl: product.productImageUrl ?? '',
            ),
          );
        }
      }
    }

    notifyListeners();
  }


  void clearBorrowedList() {
    _borrowedList.clear();
    Utils.printLog('ownerTenant rejected List cleared');
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
