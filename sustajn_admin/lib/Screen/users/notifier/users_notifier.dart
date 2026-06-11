import 'package:container_tracking/Screen/Partner/model/lease_barrow_data.dart';
import 'package:flutter/cupertino.dart';

import '../../../../constants/string_utils.dart';
import '../../Partner/model/container_history_data.dart';
import '../../Partner/model/get_container_data.dart';
import '../model/users_data.dart';

class UsersNotifier extends ChangeNotifier {
  String _name = '';
  bool _isLoading = false;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;
  UsersData? _usersData;
  List<CustomersData> _customerDataList = [];
  ContainerHistoryData? _containerHistoryData;

  LeaseBarrowData? _leaseBarrowData;
  List<DailyStats> _dailyStats = [];

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

  UsersData? get getUsersData => _usersData;

  List<CustomersData> get customerDataList => _customerDataList;

  LeaseBarrowData? get leaseBorrowData => _leaseBarrowData;

  List<DailyStats> get dailyStats => _dailyStats;

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
    // updateGroupedOrders();
    notifyListeners();
  }


}
