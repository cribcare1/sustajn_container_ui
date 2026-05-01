import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'notification_model.dart';

class NotificationState extends ChangeNotifier {
  BuildContext? _context;
  bool _isLoading = false;
  List<NotificationModel> _notificationList =[];
  BuildContext get context => _context!;
  bool get isLoading => _isLoading;
  List<NotificationModel> get   notificationList => _notificationList;

  void setContext(BuildContext context){
    _context  =context;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  void setNotificationData(List<NotificationModel> notification){
    _notificationList = notification;
    notifyListeners();
  }
}

final notificationProvider = ChangeNotifierProvider<NotificationState>(
  (ref) => NotificationState(),
);
