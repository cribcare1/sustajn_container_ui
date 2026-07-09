import 'package:container_tracking/order_request_screen/models/approve_order_data.dart';
import 'package:container_tracking/order_request_screen/models/confirm_detail_data.dart';
import 'package:container_tracking/order_request_screen/models/deliver_details_data.dart';
import 'package:container_tracking/order_request_screen/models/deliver_order_model.dart';
import 'package:container_tracking/order_request_screen/models/reject_data.dart';
import 'package:container_tracking/order_request_screen/models/reject_detail_data.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/utility.dart';
import '../models/confirm_model.dart';
import '../models/deliver_data.dart';
import '../models/pending_detail_data.dart';
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

  PendingDetailsData? _pendingDetailsData;
 // List<PendingDetailsDataList> _pendingDetailsDataList = [];

  ConfirmData? _confirmData;
  List<ConfirmDataList> _confirmDataList = [];
  ConfirmDetailsData? _confirmDetailsData;

  List<ConfirmDataList> _filterConfirmDataList = [];
  List<DeliverDataList> _filterDeliverDataList = [];
  List<RejectDataList> _filterRejectDataList = [];



  DeliverData? _deliverData;
  List<DeliverDataList> _deliverDataList = [];

  DeliverDetailData? _deliverDetailData;

  RejectOrderData? _rejectOrderData;
  List<RejectDataList> _rejectDataList = [];
  RejectDetailsData? _rejectDetailsData;

  ApproveOrder? _approveOrder;
  RejectData? _rejectData;
  DeliversData? _deliversData;
  
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
  
  PendingDetailsData? get getPendingDetailsData => _pendingDetailsData;
//  List<PendingDetailsDataList> get getPendingDetailsDataList => _pendingDetailsDataList;

  ConfirmData? get getConfirmData => _confirmData;
  List<ConfirmDataList> get getConfirmDataList => _confirmDataList;
  ConfirmDetailsData?  get getConfirmDetailsData => _confirmDetailsData;

  List<ConfirmDataList> get getFilterConfirmedDataList =>
      _filterConfirmDataList;

  DeliverData? get getDeliverData => _deliverData;
  List<DeliverDataList> get getDeliverDataList => _deliverDataList;
  List<DeliverDataList> get getFilterDeliveredDataList => _filterDeliverDataList;
  DeliverDetailData? get getDeliverDetailData => _deliverDetailData;


  RejectOrderData? get getRejectData => _rejectOrderData;
  List<RejectDataList> get getRejectDataList => _rejectDataList;
  List<RejectDataList> get getFilterRejectedDataList => _filterRejectDataList;
  RejectDetailsData? get getRejectDetailsData => _rejectDetailsData;

  ApproveOrder? get getapproveOrder => _approveOrder;
  RejectData? get getrejectData => _rejectData;
  DeliversData? get getdeliversData => _deliversData;

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

  void setPendingDetailsData(PendingDetailsData pendingDetailsData) {
    Utils.printLog("data list = ${pendingDetailsData.data!.restaurantName}");
    _pendingDetailsData = pendingDetailsData;
  //  _pendingDetailsDataList = _pendingDetailsData!.data!;
    notifyListeners();
  }

  void setConfirmData(ConfirmData confirmData) {
    Utils.printLog("data list = ${confirmData.data!.length}");
    _confirmData = confirmData;
    _confirmDataList = confirmData.data!;
    _filterConfirmDataList = _confirmDataList;
    notifyListeners();
  }

  void setConfirmDetailsData(ConfirmDetailsData confirmDetailsData) {
    Utils.printLog("data list = ${confirmDetailsData.data!.restaurantName}");
    _confirmDetailsData = confirmDetailsData;
    notifyListeners();
  }

  void setDeliverData(DeliverData deliverData) {
    Utils.printLog("data list = ${deliverData.data!.length}");
    _deliverData = deliverData;
    _deliverDataList = deliverData.data!;
    _filterDeliverDataList = _deliverDataList;
    notifyListeners();
  }

  void setDeliverDetailData(DeliverDetailData deliverDetailData) {
    Utils.printLog("data list = ${deliverDetailData.data!.restaurantName}");
    _deliverDetailData = deliverDetailData;
    notifyListeners();
  }

  void setRejectOredrData(RejectOrderData rejectOrderData) {
    Utils.printLog("data list = ${rejectOrderData.data!.length}");
    _rejectOrderData = rejectOrderData;
    _rejectDataList = rejectOrderData.data!;
    _filterRejectDataList = _rejectDataList;
    notifyListeners();
  }

  void setRejectDetailsData(RejectDetailsData rejectDetailsData) {
    Utils.printLog("data list = ${rejectDetailsData.data!.restaurantName}");
    _rejectDetailsData = rejectDetailsData;
    notifyListeners();
  }

  void setApproveOrder(ApproveOrder approveOrder) {
    Utils.printLog("data list = ${approveOrder.message}");
    _approveOrder = approveOrder;
    notifyListeners();
  }

  void setRejectData(RejectData rejectData) {
    Utils.printLog("data list = ${rejectData.message}");
    _rejectData = rejectData;
    notifyListeners();
  }

  void setDeliversData(DeliversData deliversData) {
    Utils.printLog("data list = ${deliversData.message}");
    _deliversData = deliversData;
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
      _filterConfirmDataList = _confirmDataList;
      notifyListeners();
      return;
    }
  }


  void filterDeliverByNameOrId(String query) {
    if (query.isEmpty) {
      _filterDeliverDataList = _deliverDataList;
      notifyListeners();
      return;
    }
  }


  void filterrejectByNameOrId(String query) {
    if (query.isEmpty) {
      _filterRejectDataList = _rejectDataList;
      notifyListeners();
      return;
    }
  }
}
