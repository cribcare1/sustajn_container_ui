import 'package:container_tracking/product_screen/models/incirculation_data.dart';
import 'package:container_tracking/product_screen/models/sold_data.dart';
import 'package:flutter/cupertino.dart';
import '../Screen/users/model/user_sold_container_data.dart';
import '../constants/string_utils.dart';
import '../product_screen/models/damage_data.dart';
import '../product_screen/models/with_partner_data.dart';
import '../resutants/models/get_container_data.dart';
import '../utils/utility.dart';

class OrderState extends ChangeNotifier {
  String _name = '';
  bool _isLoading = false;
  GetContainerData? _getContainerData;
  List<InventoryData> _filterInventory = [];

  BuildContext? _context;
  bool _isVerifying = false;
  List<InventoryData> _selectedContainers = [];
  bool _isOrdering = false;
  int _leasedContainerCount = 0;
  int _returnedContainerCount = 0;

  IncirculationData? _incirculationData;
  List<IncirculationList> _incirculationList = [];

  WithPartnerData? _withPartnerData;
  List<WithPartnerList> _withPartnerList = [];

  DamagedContainerData? _damagedContainerData;
  List<DamagedList> _damagedList = [];
  List<ProductsList> _productsList = [];

  SoldContainersData? _soldContainersData;
  List<SoldList> _soldList = [];
  List<ContainersList> _containersList = [];

  bool get isVerifying => _isVerifying;

  String get name => _name;

  bool get isLoading => _isLoading;

  GetContainerData? get getContainerData => _getContainerData;

  List<InventoryData> get filterInventory => _filterInventory;

  BuildContext get context => _context!;

  List<InventoryData> get selectedContainers => _selectedContainers;

  bool get isOrdering => _isOrdering;

  // Error messages
  String? _nameError;

  String? get nameError => _nameError;
  bool _isQtyAscending = true;

  bool get isQtyAscending => _isQtyAscending;

  int get leasedContainerCount => _leasedContainerCount;

  int get returnedContainerCount => _returnedContainerCount;

  IncirculationData? get getIncirculationData => _incirculationData;
  List<IncirculationList> get getIncirculationList => _incirculationList;

  WithPartnerData? get getWithPartnerData => _withPartnerData;
  List<WithPartnerList> get getPartnerDataList => _withPartnerList;

  DamagedContainerData? get getDamagedContainerData => _damagedContainerData;
  List<DamagedList> get getDamagedList => _damagedList;
  List<ProductsList> get getProductsList => _productsList;

  SoldContainersData? get getSoldContainersData => _soldContainersData;
  List<SoldList> get getSoldList => _soldList;
  List<ContainersList> get getContainersList => _containersList;

  void setLeaseCount(int count) {
    _leasedContainerCount = count;
    notifyListeners();
  }

  void setReturnCount(int count) {
    _returnedContainerCount = count;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    _validateName();
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setOrderData(GetContainerData getContainer) {
    _getContainerData = getContainer;
    _filterInventory = List.from(getContainer.inventoryData ?? []);
    notifyListeners();
  }

  void setInventoryFilter(List<InventoryData> data) {
    _filterInventory = List.from(data);
    notifyListeners();
  }

  void setIncirculationData(IncirculationData incirculationData) {
    Utils.printLog("data list = ${incirculationData.incirculationData!.length}");
    _incirculationData = incirculationData;
    _incirculationList = incirculationData!.incirculationData!;
    notifyListeners();
  }

  void setWithPartnerData(WithPartnerData withPartnerData) {
    Utils.printLog("data list = ${withPartnerData.withpartnerData!.length}");
    _withPartnerData = withPartnerData;
    _withPartnerList = withPartnerData!.withpartnerData!;
    notifyListeners();
  }

  void setDamagedData(DamagedContainerData damagedContainerData) {
    Utils.printLog("data list = ${damagedContainerData.damageData!.length}");
    _damagedContainerData = damagedContainerData;
    _damagedList = _damagedContainerData!.damageData!;
    _productsList = _productsList!;
    notifyListeners();
  }

  void setSoldContainersData(SoldContainersData soldContainersData) {
    Utils.printLog("data list = ${soldContainersData.soldData!.length}");
    _soldContainersData = soldContainersData;
    _soldList = _soldContainersData!.soldData!;
    _containersList = _containersList!;
    notifyListeners();
  }

  void filterInventoryByNameOrId(String query) {
    if (query.isEmpty) {
      _filterInventory = _getContainerData?.inventoryData ?? [];
      notifyListeners();
      return;
    }

    final lowerQuery = query.toLowerCase();

    _filterInventory = (_getContainerData?.inventoryData ?? [])
        .where((container) {
      final nameMatch =
          container.containerName?.toLowerCase().contains(lowerQuery) ??
              false;

      final idMatch = container.productId
          ?.toLowerCase()
          .contains(lowerQuery) ??
          false;

      return nameMatch || idMatch;
    })
        .toList();

    notifyListeners();
  }

  void sortByQuantity(bool ascending) {
    _isQtyAscending = ascending;
    _filterInventory.sort((a, b) {
      final aQty = a.availableContainers ?? 0;
      final bQty = b.availableContainers ?? 0;
      return ascending ? aQty.compareTo(bQty) : bQty.compareTo(aQty);
    });
    notifyListeners();
  }


  void resetSort() {
    _isQtyAscending = true;
    _filterInventory = List.from(
      _getContainerData?.inventoryData ?? [],
    );
    notifyListeners();
  }


  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  void _validateName() {
    if (_name.isEmpty) {
      _nameError = Strings.EMAIL_REQUIRED_TXT;
    } else {
      _nameError = null;
    }
  }

  void removeContainer(int id) {
    _selectedContainers.removeWhere((e) => e.inventoryId == id);
    notifyListeners();
  }

  void clearSelectedContainers() {
    _selectedContainers.clear();
    notifyListeners();
  }

  void setOrdering(bool value) {
    _isOrdering = value;
    notifyListeners();
  }

  //TODO :Lease Section
  // String _searchQuery = '';
  // Map<String, List<LeasedResponses>> _groupedOrders = {};
  // List<LeasedResponses>? _filteredResponses;
  //
  // String get searchQuery => _searchQuery;
  // Map<String, List<LeasedResponses>> get groupedOrders => _groupedOrders;
  // List<LeasedResponses>? get filteredResponses => _filteredResponses;
  // bool get hasActiveFilters => _filteredResponses != null;
  //
  // void setSearchQuery(String query) {
  //   _searchQuery = query;
  //   updateGroupedOrders();
  //   notifyListeners();
  // }
  //
  // void updateGroupedOrders() {
  //   List<LeasedResponses>? dataToGroup =
  //       _filteredResponses ?? _containerHistoryData?.data?.leasedResponses;
  //
  //   if (dataToGroup == null) {
  //     _groupedOrders = {};
  //     return;
  //   }
  //
  //   _groupedOrders = groupOrdersByMonth(dataToGroup, _searchQuery);
  //   notifyListeners();
  // }

//   Map<String, List<LeasedResponses>> groupOrdersByMonth(
//       List<LeasedResponses>? orders, String searchQuery) {
//     if (orders == null || orders.isEmpty) return {};
//
//     Map<String, List<LeasedResponses>> grouped = {};
//
//     for (var order in orders) {
//       if (searchQuery.isNotEmpty) {
//         bool matches = false;
//
//         if (order.orderId.toString().contains(searchQuery.toLowerCase())) {
//           matches = true;
//         }
//
//         if (order.productOrderListResponses != null) {
//           for (var product in order.productOrderListResponses!) {
//             if (product.productUniqueId!
//                 .toLowerCase()
//                 .contains(searchQuery.toLowerCase()) ||
//                 product.productName!
//                     .toLowerCase()
//                     .contains(searchQuery.toLowerCase())) {
//               matches = true;
//               break;
//             }
//           }
//         }
//
//         if (!matches) continue;
//       }
//
//       String monthYear = getMonthYear(order.leasedStartDateTime ?? '');
//       if (!grouped.containsKey(monthYear)) {
//         grouped[monthYear] = [];
//       }
//       grouped[monthYear]!.add(order);
//     }
//
//     return grouped;
//   }
//
//   String getMonthYear(String dateTimeStr) {
//     try {
//       List<String> parts = dateTimeStr.split('|');
//       if (parts.isEmpty) return 'Unknown';
//
//       List<String> dateParts = parts[0].split('/');
//       if (dateParts.length < 3) return 'Unknown';
//
//       int month = int.parse(dateParts[1]);
//       String year = dateParts[2];
//
//       List<String> monthNames = [
//         'January',
//         'February',
//         'March',
//         'April',
//         'May',
//         'June',
//         'July',
//         'August',
//         'September',
//         'October',
//         'November',
//         'December'
//       ];
//
//       return '${monthNames[month - 1]}-$year';
//     } catch (e) {
//       return 'Unknown';
//     }
//   }
//
//   String formatProductIds(List<ProductOrderListResponses>? products) {
//     if (products == null || products.isEmpty) return '';
//     return products.map((p) => p.productUniqueId ?? '').join(' | ');
//   }
//
//   String formatDateTime(String dateTimeStr) {
//     return dateTimeStr.replaceAll('|', ' | ');
//   }
//
//   int getMonthTotal(List<LeasedResponses> orders) {
//     return orders.fold(0, (sum, order) => sum + (order.leasedQuantity ?? 0));
//   }
//
//   void clearSearch() {
//     _searchQuery = '';
//     updateGroupedOrders();
//     notifyListeners();
//   }
//
//   void applyFilters(List<LeasedResponses> filteredData) {
//     _filteredResponses = filteredData;
//     _groupedOrders = groupOrdersByMonth(filteredData, _searchQuery);
//     notifyListeners();
//   }
//
//   void clearFilters() {
//     _filteredResponses = null;
//     _searchQuery = '';
//     updateGroupedOrders();
//     notifyListeners();
//   }
//
//   void reset() {
//     _containerHistoryData = null;
//     _searchQuery = '';
//     _groupedOrders = {};
//     _filteredResponses = null;
//     _isLoading = false;
//     notifyListeners();
//   }
//   /// receive
//
// // Add to OrderState class
//
//   /// Receive Section
//   String _searchQueryReceive = '';
//   Map<String, List<ReceivedResponses>> _groupedReceiveOrders = {};
//   List<ReceivedResponses>? _filteredReceiveResponses;
//
//   String get searchQueryReceive => _searchQueryReceive;
//   Map<String, List<ReceivedResponses>> get groupedReceiveOrders =>
//       _groupedReceiveOrders;
//   List<ReceivedResponses>? get filteredReceiveResponses =>
//       _filteredReceiveResponses;
//   bool get hasActiveFiltersReceive => _filteredReceiveResponses != null;
//
//   void setSearchQueryReceive(String query) {
//     _searchQueryReceive = query;
//     updateGroupedReceiveOrders();
//   }
//
//   void updateGroupedReceiveOrders() {
//     List<ReceivedResponses>? dataToGroup = _filteredReceiveResponses ??
//         _containerHistoryData?.data?.receivedResponses;
//
//     if (dataToGroup == null) {
//       _groupedReceiveOrders = {};
//       notifyListeners();
//       return;
//     }
//
//     _groupedReceiveOrders =
//         groupReceiveOrdersByMonth(dataToGroup, _searchQueryReceive);
//     notifyListeners();
//   }
//
//   Map<String, List<ReceivedResponses>> groupReceiveOrdersByMonth(
//       List<ReceivedResponses>? orders, String searchQuery) {
//
//     if (orders == null || orders.isEmpty) return {};
//
//     final query = searchQuery.toLowerCase();
//
//     Map<String, List<ReceivedResponses>> grouped = {};
//
//     for (var order in orders) {
//
//       if (query.isNotEmpty) {
//         bool matches = false;
//
//         // Match order ID
//         if (order.orderId.toString().contains(query)) {
//           matches = true;
//         }
//
//         // Match product details
//         if (order.productOrderListResponses != null) {
//           for (var product in order.productOrderListResponses!) {
//
//             final uniqueId =
//                 product.productUniqueId?.toLowerCase() ?? '';
//             final name =
//                 product.productName?.toLowerCase() ?? '';
//
//             if (uniqueId.contains(query) || name.contains(query)) {
//               matches = true;
//               break;
//             }
//           }
//         }
//
//         if (!matches) continue;
//       }
//
//       String monthYear = getMonthYearReceive(order.returnDateTime ?? '');
//
//       grouped.putIfAbsent(monthYear, () => []);
//       grouped[monthYear]!.add(order);
//     }
//
//     return grouped;
//   }


  String getMonthYearReceive(String dateTimeStr) {
    try {
      List<String> parts = dateTimeStr.split('|');
      if (parts.isEmpty) return 'Unknown';

      List<String> dateParts = parts[0].split('/');
      if (dateParts.length < 3) return 'Unknown';

      int month = int.parse(dateParts[1]);
      String year = dateParts[2];

      List<String> monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      return '${monthNames[month - 1]}-$year';
    } catch (e) {
      return 'Unknown';
    }
  }





  // int getMonthTotalReceive(List<ReceivedResponses> orders) {
  //   return orders.fold(0, (sum, order) => sum + (order.returnedQuantity ?? 0));
  // }

  // void clearSearchReceive() {
  //   _searchQueryReceive = '';
  //   updateGroupedReceiveOrders();
  // }

// void applyFiltersReceive(List<ReceivedResponses> filteredData) {
//   _filteredReceiveResponses = filteredData;
//   _groupedReceiveOrders =
//       groupReceiveOrdersByMonth(filteredData, _searchQueryReceive);
//   notifyListeners();
// }

// void clearFiltersReceive() {
//   _filteredReceiveResponses = null;
//   _searchQueryReceive = '';
//   updateGroupedReceiveOrders();
//   notifyListeners();
// }

///
//TODO: Month wise order history ///
// List<MonthWiseData> _monthWiseDataList =[];
// List<MonthWiseData> get monthWiseDataList => _monthWiseDataList;
// void setOrderHistory(List<MonthWiseData> data){
//   _monthWiseDataList = data;
//   notifyListeners();
// }
// List<HistoryGraphData> _orderGraph =[];
// List<HistoryGraphData> get orderGraph => _orderGraph;
// void setOrderGraph(List<HistoryGraphData> data){
//   _orderGraph = data;
//   notifyListeners();
// }
// bool _isGraphLoading = false;
// bool get isGraphLoading => _isGraphLoading;
// void setGraphLoading(bool loading){
//   _isGraphLoading = loading;
//   notifyListeners();
// }
//
//
}