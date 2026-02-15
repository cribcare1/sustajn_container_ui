import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'model/container_list_model.dart';
import 'model/container_return_list_model.dart';

class LeaseReceiveNotifier extends ChangeNotifier {
  BuildContext? _context;
  bool _isLoading = false;
  bool _isSaving = false;
  List<ContainerDetails> _containersDetails = [];
  List<ContainerDetails> _containersList = [];
List<ProductOrderListResponseList> _containerReturnList =[];
List<ProductOrderListResponseList> _containerReturnListAdded =[];
  BuildContext? get context => _context;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  List<ContainerDetails> get containersDetails => _containersDetails;
  List<ContainerDetails> get containersList => _containersList;
  List<ProductOrderListResponseList> get containerReturnList => _containerReturnList;
  List<ProductOrderListResponseList> get containerReturnListAdded => _containerReturnListAdded;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
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
  void setReturnContainer(List<ProductOrderListResponseList> containerList) {
    _containerReturnList = containerList;
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

}

final leaseReceiveNotifier = ChangeNotifierProvider<LeaseReceiveNotifier>(
  (ref) => LeaseReceiveNotifier(),
);
