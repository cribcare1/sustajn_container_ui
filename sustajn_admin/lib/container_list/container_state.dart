import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'model/container_list_model.dart';

class ContainerState extends ChangeNotifier{
  bool _isLoading = false;
  BuildContext? _context;
  File? _image;
  bool get isLoading => _isLoading;
  File? get image => _image;
  BuildContext get context => _context!;
  List<InventoryData> _containerList  = [];
  List<InventoryData> filteredContainers = [];
  List<InventoryData> get containerList  => _containerList;
  void setContainerList(List<InventoryData>? list){
    _containerList = list!;
    filteredContainers = _containerList;
    notifyListeners();
  }
  String? _errorContainer;
  String? get errorContainer => _errorContainer;
  void setContainerListError(String? error){
    _errorContainer = error;
    notifyListeners();
  }
  void filterSearch(String value) {
       filteredContainers = containerList.where((item) {
        final searchLower = value.toLowerCase();
        return item.containerName.toLowerCase().contains(searchLower) ||
            item.productId.toString().toLowerCase().contains(searchLower);
      }).toList();
      notifyListeners();
  }
  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }
  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }
  void setImage(File? file){
    _image = file;
    notifyListeners();
  }
}