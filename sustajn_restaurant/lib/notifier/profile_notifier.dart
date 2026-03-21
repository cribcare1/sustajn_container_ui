
import 'package:flutter/cupertino.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';

import '../constants/string_utils.dart';
import '../lease_receive/model/container_return_list_model.dart';
import '../models/login_model.dart';
import '../utils/utility.dart';

class ProfileState extends ChangeNotifier{
  String _name = '';
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isImageUploading = false;
  GetProfileData? _getProfileData;
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
  bool get isImageUploading => _isImageUploading;
  GetProfileData? get getProfileData => _getProfileData;
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
void setIsImageSaving(bool isLoading){
  _isImageUploading = isLoading;
    notifyListeners();
  }

  void setProfileData(GetProfileData getProfile){
    _getProfileData = getProfile;
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


///
  ///
  bool _isDamageLoading = false;
  bool get isDamageLoading => _isDamageLoading;
  void setLoading(bool loading){
    _isDamageLoading = loading;
    notifyListeners();
  }
  List<ProductOrderListResponseList> _damageContainerList =[];
  List<ProductOrderListResponseList> get damageContainerList => _damageContainerList;

  void setReturnContainer(List<ProductOrderListResponseList> containerList) {
    _damageContainerList = containerList;
    notifyListeners();
  }

}
