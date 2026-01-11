
import 'package:flutter/cupertino.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';

import '../constants/string_utils.dart';
import '../models/login_model.dart';
import '../models/update_profile_data.dart';
import '../utils/utility.dart';

class ProfileState extends ChangeNotifier{
  String _name = '';
  bool _isLoading = false;
  GetProfileData? _getProfileData;
  UpdateProfileData? _updateProfileData;
  BuildContext? _context;
  bool _isVerifying = false;

  bool get isVerifying => _isVerifying;

  String get name => _name;

  bool get isLoading => _isLoading;
  GetProfileData? get getProfileData => _getProfileData;
  UpdateProfileData? get updateProfileData => _updateProfileData!;
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

  void setProfileData(GetProfileData getProfile){
    _getProfileData = getProfile;
    notifyListeners();
  }

  void setUpdateProfileData(UpdateProfileData updateProfile){
    _updateProfileData = updateProfile;
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
