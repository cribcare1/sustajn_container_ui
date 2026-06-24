import 'package:flutter/cupertino.dart';

class UsersNotifier extends ChangeNotifier {

  bool _isLoading = false;
  String _searchQuery = '';

  String get searchQuery => _searchQuery;
  BuildContext? _context;

  int _leasedContainerCount = 0;
  int _returnedContainerCount = 0;


  bool get isLoading => _isLoading;

  BuildContext get context => _context!;


  // Error messages
  String? _nameError;

  String? get nameError => _nameError;
  bool _isQtyAscending = true;

  bool get isQtyAscending => _isQtyAscending;

  int get leasedContainerCount => _leasedContainerCount;

  int get returnedContainerCount => _returnedContainerCount;

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
