import 'package:flutter/cupertino.dart';

import '../../utils/utility.dart';
import '../models/pending_model.dart';

class OrderRequestNotifier extends ChangeNotifier {

  bool _isLoading = false;
  String _searchQuery = '';
  // Error messages
  String? _nameError;
  String get searchQuery => _searchQuery;
  BuildContext? _context;

  PendingData? _pendingData;
  List<PendingDataList> _pendingDataList = [];

  int _leasedContainerCount = 0;
  int _returnedContainerCount = 0;


  bool get isLoading => _isLoading;

  BuildContext get context => _context!;
  //Getter
  String? get nameError => _nameError;
  bool _isQtyAscending = true;

  bool get isQtyAscending => _isQtyAscending;

  int get leasedContainerCount => _leasedContainerCount;

  int get returnedContainerCount => _returnedContainerCount;
  PendingData? get getPendingData => _pendingData;
  List<PendingDataList> get getPendingDataList => _pendingDataList;
//Setter
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

  void setPendingData(PendingData pendingData) {
    Utils.printLog("data list = ${pendingData.data!.length}");
    _pendingData = pendingData;
    _pendingDataList = pendingData!.data!;
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
