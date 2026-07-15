import 'package:container_tracking/Screen/Partner/model/lease_barrow_data.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/utility.dart';
import '../../Partner/model/container_history_data.dart';
import '../../Partner/model/get_container_data.dart';
import '../model/user_borrow_details_data.dart';
import '../model/user_borrowed_data.dart';
import '../model/user_damage_data.dart';
import '../model/user_product_data.dart';
import '../model/user_sold_container_data.dart';
import '../model/users_data.dart';

class UsersNotifier extends ChangeNotifier {
  String _name = '';
  bool _isLoading = false;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;
  UsersData? _usersData;
  List<CustomersData> _customerDataList = [];
  ContainerHistoryData? _containerHistoryData;
  UserDamageData? _userDamageData;
  List<DamageDataList> _damageDataList = [];
  LeaseBarrowData? _leaseBarrowData;
  List<DailyStats> _dailyStats = [];
  ProductData? _productData;
  SoldContainerData? _soldContainerData;
  List<SoldDataList> _soldContainerList = [];

  List<ProductDataList> _productList = [];
  List<BorrowedUiItem> _borrowedList = [];

  List<BorrowedUiItem> get borrowedList => _borrowedList;
  BuildContext? _context;
  bool _isVerifying = false;
  List<ContainersDetails> _selectedContainers = [];
  bool _isOrdering = false;
  int _leasedContainerCount = 0;
  int _returnedContainerCount = 0;

  bool get isVerifying => _isVerifying;

  String get name => _name;

  bool get isLoading => _isLoading;

  UsersData? get getUsersData => _usersData;

  UserDamageData? get getUserDamageData => _userDamageData;

  List<CustomersData> get customerDataList => _customerDataList;

  List<DamageDataList> get userDamageList => _damageDataList;

  ProductData get productData => _productData!;

  List<ProductDataList> get productList => _productList;

  LeaseBarrowData? get leaseBorrowData => _leaseBarrowData;

  List<DailyStats> get dailyStats => _dailyStats;

  List<SoldDataList> get filteredList => filteredList;

  SoldContainerData? get soldContainerData => _soldContainerData;

  List<SoldDataList> get soldContainerList => _soldContainerList;

  ContainerHistoryData? get containerHistorydata => _containerHistoryData;

  BuildContext get context => _context!;

  List<ContainersDetails> get selectedContainers => _selectedContainers;

  bool get isOrdering => _isOrdering;

  String? _nameError;

  String? get nameError => _nameError;
  bool _isQtyAscending = true;

  bool get isQtyAscending => _isQtyAscending;

  int get leasedContainerCount => _leasedContainerCount;

  int get returnedContainerCount => _returnedContainerCount;

  void setLeaseCount(int count) {
    _leasedContainerCount = count;
    notifyListeners();
  }

  void setFilteredList(List<SoldDataList> list) {
    var _filteredList = list;
    notifyListeners();
  }

  void setReturnCount(int count) {
    _returnedContainerCount = count;
    notifyListeners();
  }

  void setProductData(ProductData data) {
    _productData = data;
    _productList = data.data!;
    notifyListeners();
  }

  void setSoldContainerData(SoldContainerData soldContainer) {
    _soldContainerList.clear();
    _soldContainerData = soldContainer;
    _soldContainerList.addAll(soldContainer.data ?? []);
    notifyListeners();
  }

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

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setUsersData(UsersData usersData) {
    _usersData = usersData;
    _customerDataList = List.from(usersData.customersData ?? []);
    notifyListeners();
  }

  void setLeaseBorrowData(LeaseBarrowData leaseBarrowData) {
    _leaseBarrowData = leaseBarrowData;
    _dailyStats = List.from(
      _leaseBarrowData!.leaseBarrowData!.dailyStats ?? [],
    );
    notifyListeners();
  }

  void setInventoryFilter(List<CustomersData> data) {
    _customerDataList = List.from(data);
    notifyListeners();
  }

  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  void setUsersDamageData(UserDamageData userDamageData) {
    _userDamageData = userDamageData;
    _damageDataList = List.from(userDamageData.data ?? []);
    notifyListeners();
  }
}
