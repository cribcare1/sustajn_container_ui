import 'package:container_tracking/order_request_screen/models/deliver_order_model.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/utility.dart';
import '../models/confirm_model.dart';
import '../models/pending_model.dart';
import '../models/reject_order_model.dart';

class OrderRequestNotifier extends ChangeNotifier {

  bool _isLoading = false;
  String _searchQuery = '';

  // Error messages
  String? _nameError;

  String get searchQuery => _searchQuery;
  BuildContext? _context;

  PendingData? _pendingData;
  List<PendingDataList> _pendingDataList = [];

  ConfirmData? _confirmData;
  List<ConfirmDataList> _confirmDataList = [];
  List<ConfirmDataList> _filterConfirmDataList = [];
  List<DeliverDataList> _filterDeliverDataList = [];
  List<RejectDataList> _filterRejectDataList = [];



  DeliverData? _deliverData;
  List<DeliverDataList> _deliverDataList = [];

  RejectOrderData? _rejectOrderData;
  List<RejectDataList> _rejectDataList = [];

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

  ConfirmData? get getConfirmData => _confirmData;
  List<ConfirmDataList> get getConfirmDataList => _confirmDataList;
  List<ConfirmDataList> get getFilterConfirmedDataList =>
      _filterConfirmDataList;

  DeliverData? get getDeliverData => _deliverData;
  List<DeliverDataList> get getDeliverDataList => _deliverDataList;
  List<DeliverDataList> get getFilterDeliveredDataList => _filterDeliverDataList;


  RejectOrderData? get getRejectData => _rejectOrderData;
  List<RejectDataList> get getRejectDataList => _rejectDataList;
  List<RejectDataList> get getFilterRejectedDataList => _filterRejectDataList;


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

  void setConfirmData(ConfirmData confirmData) {
    Utils.printLog("data list = ${confirmData.data!.length}");
    _confirmData = confirmData;
    _confirmDataList = confirmData!.data!;
    _filterConfirmDataList = _confirmDataList ?? [];
    notifyListeners();
  }

  void setDeliverData(DeliverData deliverData) {
    Utils.printLog("data list = ${deliverData.data!.length}");
    _deliverData = deliverData;
    _deliverDataList = deliverData!.data!;
    _filterDeliverDataList = _deliverDataList ?? [];
    notifyListeners();
  }

  void setRejectOredrData(RejectOrderData rejectOrderData) {
    Utils.printLog("data list = ${rejectOrderData.data!.length}");
    _rejectOrderData = rejectOrderData;
    _rejectDataList = rejectOrderData!.data!;
    _filterRejectDataList = _rejectDataList ?? [];
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

  void filterInventoryByNameOrId(String query) {
    if (query.isEmpty) {
      _filterConfirmDataList = _confirmDataList ?? [];
      notifyListeners();
      return;
    }
  }


  void filterDeliverByNameOrId(String query) {
    if (query.isEmpty) {
      _filterDeliverDataList = _deliverDataList ?? [];
      notifyListeners();
      return;
    }
  }


  void filterrejectByNameOrId(String query) {
    if (query.isEmpty) {
      _filterRejectDataList = _rejectDataList ?? [];
      notifyListeners();
      return;
    }
  }
}
