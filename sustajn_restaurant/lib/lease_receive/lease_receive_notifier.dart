import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'model/container_list_model.dart';
import 'model/container_return_list_model.dart';

class LeaseReceiveNotifier extends ChangeNotifier {
  BuildContext? _context;
  bool _isLoading = false;
  bool _isSaving = false;
  int _customerUserId = 0;
  List<ContainerDetails> _containersDetails = [];
  List<ContainerDetails> _containersList = [];
List<ProductOrderListResponseList> _containerReturnList =[];
List<ProductOrderListResponseList> _containerReturnListAdded =[];

//Get
  BuildContext? get context => _context;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  int get customerUserId => _customerUserId;
  List<ContainerDetails> get containersDetailsList => _containersDetails;
  List<ContainerDetails> get containersList => _containersList;
  List<ProductOrderListResponseList> get containerReturnList => _containerReturnList;
  List<ProductOrderListResponseList> get containerReturnListAdded => _containerReturnListAdded;

  //Set
  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setCustomerUserId(int userId) {
    _customerUserId = userId;
    notifyListeners();
  }

  void clearAddedContainer(){
    _containersList = [];
    notifyListeners();
  }

  void setIsSaving(bool isSaving) {
    _isSaving = isSaving;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  void setContainer(List<ContainerDetails> containerList) {
    _containersDetails = containerList;
    notifyListeners();
  }
  ///Return
  int _containerCount = 0;

  int get containerCount => _containerCount;
Map<String, int> _totalCount ={};
Map<String, int> get totalCount => _totalCount;

  void setReturnContainer(
      List<ProductOrderListResponseList> containerList) {

    _containerReturnListAdded.clear();
    _containerReturnList.clear();

    _containerReturnList = containerList;

    _containerCount = _containerReturnList.fold(
      0,
          (sum, item) => sum + item.quantity,
    );

    for (var item in _containerReturnList) {
      final key = item.productUniqueId;

      if (_totalCount.containsKey(key)) {
        _totalCount[key] = _totalCount[key]! + item.quantity;
      } else {
        _totalCount[key] = item.quantity;
      }
    }
    notifyListeners();
  }
  void setReturnContainerAdd(ProductOrderListResponseList containerList) {
    _containerReturnListAdded.add(containerList);
    notifyListeners();
  }
  void setContainerReturnList(ProductOrderListResponseList container) {
    final exists = _containerReturnListAdded.any(
          (e) => e.productUniqueId == container.productUniqueId,
    );

    if (!exists) {
      _containerReturnListAdded.add(container);
      notifyListeners();
    }
  }
  ///
  void setContainerList(ContainerDetails container) {
    final exists = _containersList.any(
          (e) => e.containerUniqueId == container.containerUniqueId,
    );

    if (!exists) {
      _containersList.add(container);
      notifyListeners();
    }
  }
  void removeContainer(int index) {
    _containersList.removeAt(index);
    notifyListeners();
  }
}

final leaseReceiveNotifier = ChangeNotifierProvider.autoDispose<LeaseReceiveNotifier>(
  (ref) => LeaseReceiveNotifier(),
);
