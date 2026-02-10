
import 'package:flutter/cupertino.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';

import '../constants/string_utils.dart';
import '../models/login_model.dart';
import '../utils/utility.dart';

class ProfileState extends ChangeNotifier{
  String _name = '';
  bool _isLoading = false;
  bool _isSaving = false;
  GetProfileData? _getProfileData;
  // UpdateProfileData? _updateProfileData;
  BuildContext? _context;
  bool _isVerifying = false;
  LoginData? _loginResponse;

  // Error messages
  String? _nameError;

  String? get nameError => _nameError;

  //Getter for all
  bool get isVerifying => _isVerifying;
  String get name => _name;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  GetProfileData? get getProfileData => _getProfileData;
  // UpdateProfileData? get updateProfileData => _updateProfileData!;
  BuildContext get context => _context!;
  LoginData? get loginResponse => _loginResponse;

// Setter for all
  void setName(String value) {
    _name = value;
    _validateName();
    notifyListeners();
  }

  Future<void> setProfile() async {
    await Utils.getProfile();
    _loginResponse = Utils.loginData?.data;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }
void setIsSaving(bool isLoading){
    _isSaving = isLoading;
    notifyListeners();
  }

  void setProfileData(GetProfileData getProfile){
    _getProfileData = getProfile;
    notifyListeners();
  }

  // void setUpdateProfileData(UpdateProfileData updateProfile){
  //   _updateProfileData = updateProfile;
  //   notifyListeners();
  // }

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
