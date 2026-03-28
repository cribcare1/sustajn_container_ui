import 'package:flutter/cupertino.dart';

import '../../../../constants/string_utils.dart';
import '../../model/container_history_data.dart';
import '../../model/get_container_data.dart';

class OrderState extends ChangeNotifier {
  String _name = '';
  bool _isLoading = false;
  GetContainerData? _getContainerData;
  List<ContainersDetails> _filterInventory = [];
  ContainerHistoryData? _containerHistoryData;

  // DamagedContainerData? _damagedContainerData;
  // SoldContainerData? _soldContainerData;
  BuildContext? _context;
  bool _isVerifying = false;
  List<ContainersDetails> _selectedContainers = [];
  bool _isOrdering = false;
  int _leasedContainerCount = 0;
  int _returnedContainerCount = 0;

  bool get isVerifying => _isVerifying;

  String get name => _name;

  bool get isLoading => _isLoading;

  GetContainerData? get getContainerData => _getContainerData;

  List<ContainersDetails> get filterInventory => _filterInventory;

  ContainerHistoryData? get containerHistorydata => _containerHistoryData;

  // DamagedContainerData? get damagedContainerData => _damagedContainerData;
  // SoldContainerData? get soldContainerData => _soldContainerData;
  BuildContext get context => _context!;

  List<ContainersDetails> get selectedContainers => _selectedContainers;

  bool get isOrdering => _isOrdering;

  // Error messages
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
    _filterInventory = List.from(getContainer.containersDetails ?? []);
    notifyListeners();
  }

  void setInventoryFilter(List<ContainersDetails> data) {
    _filterInventory = List.from(data);
    notifyListeners();
  }

  void filterInventoryByNameOrId(String query) {
    if (query.isEmpty) {
      _filterInventory = _getContainerData?.containersDetails ?? [];
      notifyListeners();
      return;
    }

    final lowerQuery = query.toLowerCase();

    _filterInventory = (_getContainerData?.containersDetails ?? []).where((
      container,
    ) {
      final nameMatch =
          container.containerName?.toLowerCase().contains(lowerQuery) ?? false;

      final idMatch =
          container.containerUniqueId?.toLowerCase().contains(lowerQuery) ??
          false;

      return nameMatch || idMatch;
    }).toList();

    notifyListeners();
  }

  void sortByQuantity(bool ascending) {
    _isQtyAscending = ascending;
    _filterInventory.sort((a, b) {
      final aQty = a.quantityAvailable ?? 0;
      final bQty = b.quantityAvailable ?? 0;
      return ascending ? aQty.compareTo(bQty) : bQty.compareTo(aQty);
    });
    notifyListeners();
  }

  void resetSort() {
    _isQtyAscending = true;
    _filterInventory = List.from(_getContainerData?.containersDetails ?? []);
    notifyListeners();
  }

  void setContainerHistoryData(ContainerHistoryData containerHistory) {
    _containerHistoryData = containerHistory;
    updateGroupedOrders();
    updateGroupedReceiveOrders();
    notifyListeners();
  }

  // void setDamagedContainerData(DamagedContainerData damagedContainer){
  //   _damagedContainerData = damagedContainer;
  //   notifyListeners();
  // }
  //
  // void setSoldContainerData(SoldContainerData soldContainer){
  //   _soldContainerData = soldContainer;
  //   notifyListeners();
  // }

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

  void addContainerToOrder(ContainersDetails item, int qty) {
    final index = _selectedContainers.indexWhere(
      (e) => e.containerId == item.containerId,
    );

    if (index >= 0) {
      _selectedContainers[index].quantityAvailable = qty;
    } else {
      _selectedContainers.add(
        ContainersDetails(
          containerId: item.containerId,
          containerName: item.containerName,
          containerUniqueId: item.containerUniqueId,
          capacity: item.capacity,
          containerImageUrl: item.containerImageUrl,
          quantityAvailable: qty,
        ),
      );
    }
    notifyListeners();
  }

  void removeContainer(int id) {
    _selectedContainers.removeWhere((e) => e.containerId == id);
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

  /// Lease Section
  String _searchQuery = '';
  Map<String, List<LeasedResponses>> _groupedOrders = {};
  List<LeasedResponses>? _filteredResponses;

  String get searchQuery => _searchQuery;

  Map<String, List<LeasedResponses>> get groupedOrders => _groupedOrders;

  List<LeasedResponses>? get filteredResponses => _filteredResponses;

  bool get hasActiveFilters => _filteredResponses != null;

  void setSearchQuery(String query) {
    _searchQuery = query;
    updateGroupedOrders();
    notifyListeners();
  }

  void updateGroupedOrders() {
    List<LeasedResponses>? dataToGroup =
        _filteredResponses ?? _containerHistoryData?.data?.leasedResponses;

    if (dataToGroup == null) {
      _groupedOrders = {};
      return;
    }

    _groupedOrders = groupOrdersByMonth(dataToGroup, _searchQuery);
    notifyListeners();
  }

  Map<String, List<LeasedResponses>> groupOrdersByMonth(
    List<LeasedResponses>? orders,
    String searchQuery,
  ) {
    if (orders == null || orders.isEmpty) return {};

    Map<String, List<LeasedResponses>> grouped = {};

    for (var order in orders) {
      if (searchQuery.isNotEmpty) {
        bool matches = false;

        if (order.orderId.toString().contains(searchQuery.toLowerCase())) {
          matches = true;
        }

        if (order.productOrderListResponses != null) {
          for (var product in order.productOrderListResponses!) {
            if (product.productUniqueId!.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ||
                product.productName!.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                )) {
              matches = true;
              break;
            }
          }
        }

        if (!matches) continue;
      }

      String monthYear = getMonthYear(order.leasedStartDateTime ?? '');
      if (!grouped.containsKey(monthYear)) {
        grouped[monthYear] = [];
      }
      grouped[monthYear]!.add(order);
    }

    return grouped;
  }

  String getMonthYear(String dateTimeStr) {
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
        'December',
      ];

      return '${monthNames[month - 1]}-$year';
    } catch (e) {
      return 'Unknown';
    }
  }

  String formatProductIds(List<ProductOrderListResponses>? products) {
    if (products == null || products.isEmpty) return '';
    return products.map((p) => p.productUniqueId ?? '').join(' | ');
  }

  String formatDateTime(String dateTimeStr) {
    return dateTimeStr.replaceAll('|', ' | ');
  }

  int getMonthTotal(List<LeasedResponses> orders) {
    return orders.fold(0, (sum, order) => sum + (order.leasedQuantity ?? 0));
  }

  void clearSearch() {
    _searchQuery = '';
    updateGroupedOrders();
    notifyListeners();
  }

  void applyFilters(List<LeasedResponses> filteredData) {
    _filteredResponses = filteredData;
    _groupedOrders = groupOrdersByMonth(filteredData, _searchQuery);
    notifyListeners();
  }

  void clearFilters() {
    _filteredResponses = null;
    _searchQuery = '';
    updateGroupedOrders();
    notifyListeners();
  }

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
  // Add to OrderState class

  /// Receive Section
  String _searchQueryReceive = '';
  Map<String, List<ReceivedResponses>> _groupedReceiveOrders = {};
  List<ReceivedResponses>? _filteredReceiveResponses;

  String get searchQueryReceive => _searchQueryReceive;

  Map<String, List<ReceivedResponses>> get groupedReceiveOrders =>
      _groupedReceiveOrders;

  List<ReceivedResponses>? get filteredReceiveResponses =>
      _filteredReceiveResponses;

  bool get hasActiveFiltersReceive => _filteredReceiveResponses != null;

  void setSearchQueryReceive(String query) {
    _searchQueryReceive = query;
    updateGroupedReceiveOrders();
  }

  void updateGroupedReceiveOrders() {
    List<ReceivedResponses>? dataToGroup =
        _filteredReceiveResponses ??
        _containerHistoryData?.data?.receivedResponses;

    if (dataToGroup == null) {
      _groupedReceiveOrders = {};
      notifyListeners();
      return;
    }

    _groupedReceiveOrders = groupReceiveOrdersByMonth(
      dataToGroup,
      _searchQueryReceive,
    );
    notifyListeners();
  }

  Map<String, List<ReceivedResponses>> groupReceiveOrdersByMonth(
    List<ReceivedResponses>? orders,
    String searchQuery,
  ) {
    if (orders == null || orders.isEmpty) return {};

    final query = searchQuery.toLowerCase();

    Map<String, List<ReceivedResponses>> grouped = {};

    for (var order in orders) {
      if (query.isNotEmpty) {
        bool matches = false;

        // Match order ID
        if (order.orderId.toString().contains(query)) {
          matches = true;
        }

        // Match product details
        if (order.productOrderListResponses != null) {
          for (var product in order.productOrderListResponses!) {
            final uniqueId = product.productUniqueId?.toLowerCase() ?? '';
            final name = product.productName?.toLowerCase() ?? '';

            if (uniqueId.contains(query) || name.contains(query)) {
              matches = true;
              break;
            }
          }
        }

        if (!matches) continue;
      }

      String monthYear = getMonthYearReceive(order.returnDateTime ?? '');

      grouped.putIfAbsent(monthYear, () => []);
      grouped[monthYear]!.add(order);
    }

    return grouped;
  }

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
        'December',
      ];

      return '${monthNames[month - 1]}-$year';
    } catch (e) {
      return 'Unknown';
    }
  }

  int getMonthTotalReceive(List<ReceivedResponses> orders) {
    return orders.fold(0, (sum, order) => sum + (order.returnedQuantity ?? 0));
  }

  void clearSearchReceive() {
    _searchQueryReceive = '';
    updateGroupedReceiveOrders();
  }

  void applyFiltersReceive(List<ReceivedResponses> filteredData) {
    _filteredReceiveResponses = filteredData;
    _groupedReceiveOrders = groupReceiveOrdersByMonth(
      filteredData,
      _searchQueryReceive,
    );
    notifyListeners();
  }

  void clearFiltersReceive() {
    _filteredReceiveResponses = null;
    _searchQueryReceive = '';
    updateGroupedReceiveOrders();
    notifyListeners();
  }
  //
  // ///
  // /// Month wise order history ///
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
}
