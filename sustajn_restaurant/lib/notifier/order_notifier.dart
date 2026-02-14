
import 'package:flutter/cupertino.dart';

import '../constants/string_utils.dart';
import '../models/container_history_data.dart';
import '../models/get_container_data.dart';

class OrderState extends ChangeNotifier{
  String _name = '';
  bool _isLoading = false;
  GetContainerData? _getContainerData;
  ContainerHistoryData? _containerHistoryData;
  BuildContext? _context;
  bool _isVerifying = false;
  List<ContainersDetails> _selectedContainers = [];
  bool _isOrdering = false;

  bool get isVerifying => _isVerifying;

  String get name => _name;

  bool get isLoading => _isLoading;
  GetContainerData? get getContainerData => _getContainerData;
  ContainerHistoryData? get containerHistorydata => _containerHistoryData;
  BuildContext get context => _context!;
  List<ContainersDetails> get selectedContainers => _selectedContainers;
  bool get isOrdering => _isOrdering;

  // Error messages
  String? _nameError;

  String? get nameError => _nameError;

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
