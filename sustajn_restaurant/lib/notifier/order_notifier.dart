
import 'package:flutter/cupertino.dart';

import '../constants/string_utils.dart';
import '../models/container_history_data.dart';
import '../models/damaged_container_data.dart';
import '../models/get_container_data.dart';

class OrderState extends ChangeNotifier{
  String _name = '';
  bool _isLoading = false;
  GetContainerData? _getContainerData;
  List<ContainersDetails> _filterInventory = [];
  ContainerHistoryData? _containerHistoryData;
  DamagedContainerData? _damagedContainerData;
  BuildContext? _context;
  bool _isVerifying = false;
  List<ContainersDetails> _selectedContainers = [];
  bool _isOrdering = false;

  bool get isVerifying => _isVerifying;

  String get name => _name;

  bool get isLoading => _isLoading;
  GetContainerData? get getContainerData => _getContainerData;
  List<ContainersDetails> get filterInventory => _filterInventory;
  ContainerHistoryData? get containerHistorydata => _containerHistoryData;
  DamagedContainerData? get damagedContainerData => _damagedContainerData;
  BuildContext get context => _context!;
  List<ContainersDetails> get selectedContainers => _selectedContainers;
  bool get isOrdering => _isOrdering;

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

  void setDamagedContainerData(DamagedContainerData damagedContainer){
    _damagedContainerData = damagedContainer;
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



}
