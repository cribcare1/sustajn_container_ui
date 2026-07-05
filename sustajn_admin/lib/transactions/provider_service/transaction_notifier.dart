import 'package:flutter/cupertino.dart';

import '../../Screen/users/model/user_sold_container_data.dart';
import '../../order_request_screen/models/pending_model.dart';
import '../../utils/utility.dart';
import '../models/transaction_extendedfee_data.dart';
import '../models/transaction_subscription_data.dart';


class TransactionNotifier extends ChangeNotifier {

  bool _isLoading = false;
  String _searchQuery = '';
  // Error messages
  String? _nameError;
  BuildContext? _context;

  SubscriptionData? _subscriptionData;
  List<SubscriptionDataList> _subscriptionDataList = [];

  SoldContainerData? _soldContainerData;
  List<SoldDataList> _soldContainerDataList = [];

  ExtendedFeeData? _extendedFeeData;
  List<ExtendedFeeDataList> _extendedFeeDataList = [];

  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  BuildContext get context => _context!;

  //Getter
  String? get nameError => _nameError;

  SubscriptionData? get getSubscriptionData => _subscriptionData;
  List<SubscriptionDataList> get getSubscriptionDataList => _subscriptionDataList;

  SoldContainerData? get getSoldContainerData => _soldContainerData;
  List<SoldDataList> get getSoldContainerDataList => _soldContainerDataList;

  ExtendedFeeData? get getExtendedFeeData => _extendedFeeData;
  List<ExtendedFeeDataList> get getExtendedFeeDataList => _extendedFeeDataList;

//Setter

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setSubscriptionData(SubscriptionData subscriptionData) {
    Utils.printLog("data list = ${subscriptionData.data!.length}");
    _subscriptionData = subscriptionData;
    _subscriptionDataList = subscriptionData!.data!;
    notifyListeners();
  }

  void setSoldContainerData(SoldContainerData soldContainerData) {
    Utils.printLog("data list = ${soldContainerData.data!.length}");
    _soldContainerData = soldContainerData;
    _soldContainerDataList = soldContainerData!.data!;
    notifyListeners();
  }

  void setExtendedFeeData(ExtendedFeeData extendedFeeData) {
    Utils.printLog("data list = ${extendedFeeData.data!.length}");
    _extendedFeeData = extendedFeeData;
    _extendedFeeDataList = extendedFeeData!.data!;
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
