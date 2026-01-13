import 'package:flutter/material.dart';

import '../models/product_data.dart';
import '../models/profile_model.dart';
import '../utils/utils.dart';

class ProfileNotifier extends ChangeNotifier {
  bool _isLoading = false;
  BuildContext? _context;

  ProfileData? _profileData;

  List<ProfileList> _profileList = [];

  bool get isLoading => _isLoading;

  BuildContext get context => _context!;

  ProfileData get profileData => _profileData!;

  List<ProfileList> get profileList => _profileList;

  void setProfileList(ProfileData data) {
    _profileData = data;

    if (data.data != null) {
      _profileList = [data.data!];
    } else {
      _profileList = [];
    }

    notifyListeners();
  }


  void clearProfileList() {
    _profileList.clear();
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
}
