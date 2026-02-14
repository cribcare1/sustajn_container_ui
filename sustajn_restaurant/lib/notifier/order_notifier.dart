
import 'package:flutter/cupertino.dart';

import '../constants/string_utils.dart';
import '../models/container_history_data.dart';
import '../models/get_container_data.dart';

class OrderState extends ChangeNotifier{
  String _name = '';
  bool _isLoading = false;
  GetContainerData? _getContainerData;
  List<ContainersDetails> _filterInventory = [];
  ContainerHistoryData? _containerHistoryData;
  BuildContext? _context;
  bool _isVerifying = false;

  bool get isVerifying => _isVerifying;

  String get name => _name;

  bool get isLoading => _isLoading;
  GetContainerData? get getContainerData => _getContainerData;
  List<ContainersDetails> get filterInventory => _filterInventory;
  ContainerHistoryData? get containerHistorydata => _containerHistoryData;
  BuildContext get context => _context!;

  // Error messages
  String? _nameError;

  String? get nameError => _nameError;
  bool _isQtyAscending = true;

  bool get isQtyAscending => _isQtyAscending;

  void setName(String value) {
    _name = value;
    _validateName();
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  void setOrderData(GetContainerData getContainer){
    _getContainerData = getContainer;
    _filterInventory = List.from(getContainer.containersDetails ?? []);
    notifyListeners();
  }
  void setInventoryFilter(List<ContainersDetails> data){
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

    _filterInventory = (_getContainerData?.containersDetails ?? [])
        .where((container) {
      final nameMatch = container.containerName
          ?.toLowerCase()
          .contains(lowerQuery) ??
          false;

      final idMatch = container.containerUniqueId
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
      final aQty = a.quantityAvailable ?? 0;
      final bQty = b.quantityAvailable ?? 0;
      return ascending
          ? aQty.compareTo(bQty)
          : bQty.compareTo(aQty);
    });
    notifyListeners();
  }


  void resetSort() {
    _isQtyAscending = true;
    _filterInventory = List.from(
      _getContainerData?.containersDetails ?? [],
    );
    notifyListeners();
  }



  void setContainerHistoryData(ContainerHistoryData containerHistory){
    _containerHistoryData = containerHistory;
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



}
