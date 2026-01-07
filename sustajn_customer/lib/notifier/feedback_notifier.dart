import 'package:flutter/cupertino.dart';

import '../models/register_data.dart';
import '../models/subscriptionplan_data.dart';

class FeedbackNotifier extends ChangeNotifier {
  bool _isLoading = false;

  BuildContext? _context;
  RegistrationData? _registrationData;
  SubscriptionModel? _subscriptionModel;
  List<SubscriptionData>? data = [];

  bool get isLoading => _isLoading;

  RegistrationData? get registrationData => _registrationData;

  SubscriptionModel? get subscriptionModel => _subscriptionModel;

  List<SubscriptionData>? get subscriptionList => data;

  // Error messages
  String? _nameError;
  String? _passwordError;

  String? get nameError => _nameError;

  String? get passwordError => _passwordError;

  BuildContext get context => _context!;

  void setRegistrationData(RegistrationData registrationData) {
    _registrationData = registrationData;
    notifyListeners();
  }

  void setSubscriptionModel(SubscriptionModel subscriptionModel) {
    _subscriptionModel = subscriptionModel;
    data = subscriptionModel.data;
    notifyListeners();
  }

  void setContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}

