import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';

class NotificationState extends ChangeNotifier {
  BuildContext? _context;
  bool _isLoading = false;

  BuildContext get context => _context!;
  bool get isLoading => _isLoading;

  void setContext(BuildContext context){
    _context  =context;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}

final notificationProvider = ChangeNotifierProvider<NotificationState>(
  (ref) => NotificationState(),
);
