
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

  bool get isVerifying => _isVerifying;

  String get name => _name;

  bool get isLoading => _isLoading;
  GetContainerData? get getContainerData => _getContainerData;
  ContainerHistoryData? get containerHistorydata => _containerHistoryData;
  BuildContext get context => _context!;

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



}
