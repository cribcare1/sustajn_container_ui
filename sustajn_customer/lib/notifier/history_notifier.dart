import 'package:flutter/material.dart';

import '../profile_screen/history_screen/model/borrowed_data.dart';
import '../profile_screen/history_screen/model/borrowed_items.dart';
import '../profile_screen/history_screen/model/sold_container_data.dart';
import '../utils/utils.dart';

class HistoryNotifier extends ChangeNotifier {
  bool _isLoading = false;
  SoldContainerData? _soldContainerData;

  BuildContext? _context;

  BorrowedData? _borrowedData;
List<SoldData> _soldContainerList = [];

  List<BorrowedUiItem> _borrowedList = [];


  bool get isLoading => _isLoading;

  BuildContext get context => _context!;

  List<BorrowedUiItem> get borrowedList => _borrowedList;

  SoldContainerData? get soldContainerData => _soldContainerData;

  List<SoldData> get soldContainerList => _soldContainerList;


  void setBorrowedData(BorrowedData data) {
    _borrowedList = [];

    final value = data.value;
    if (value == null) return;

    final Map<String, List<December>> monthMap = {
      "January": value.january?.cast<December>() ?? [],
      "February": value.february?.cast<December>() ?? [],
      "March": value.march?.cast<December>() ?? [],
      "April": value.april?.cast<December>() ?? [],
      "May": value.may?.cast<December>() ?? [],
      "June": value.june?.cast<December>() ?? [],
      "July": value.july?.cast<December>() ?? [],
      "August": value.august?.cast<December>() ?? [],
      "September": value.september?.cast<December>() ?? [],
      "October": value.october?.cast<December>() ?? [],
      "November": value.november?.cast<December>() ?? [],
      "December": value.december ?? [],
    };

    monthMap.forEach((month, orders) {
      for (final order in orders) {
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
              productId: product.productUniqueId ?? '',
              date: date,
              time: time,
              imageUrl: product.productImageUrl ?? '',
              returnedDate: order.returnedDate,
              returnedTime: order.returnedTime,
            ),
          );
        }
      }
    });

    notifyListeners();
  }





  void clearBorrowedList() {
    _borrowedList.clear();
    Utils.printLog('ownerTenant rejected List cleared');
    notifyListeners();
  }

  void setSoldContainerData(SoldContainerData soldContainer){
    _soldContainerList.clear();
    _soldContainerData = soldContainer;
    _soldContainerList.addAll(soldContainer.data??[]);
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
