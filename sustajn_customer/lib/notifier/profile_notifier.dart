import 'package:flutter/material.dart';

import '../models/get_profile_model.dart';

class ProfileNotifier extends ChangeNotifier {
  bool _isLoading = false;
  BuildContext? _context;

  GetProfileModel? _profileData;

  List<ProfileData> _profileList = [];

  bool get isLoading => _isLoading;

  BuildContext get context => _context!;

  GetProfileModel? get profileModel => _profileData;

  ProfileData? get profileData => _profileData?.data;

  List<ProfileData> get profileList => _profileList;

  void setProfileList(GetProfileModel data) {
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

  void removeAddressById(int addressId) {
    if (_profileList.isEmpty) return;

    _profileList.first.addressResponses = List<AddressResponses>.from(
      _profileList.first.addressResponses ?? [],
    )..removeWhere((element) => element.id == addressId);

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
