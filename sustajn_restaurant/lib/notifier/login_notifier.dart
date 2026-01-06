
import 'package:flutter/cupertino.dart';

import '../auth/model/payment_type_model.dart';
import '../auth/model/social_media_model.dart';
import '../constants/string_utils.dart';
import '../models/login_model.dart';
import '../models/registration_data.dart';
import '../utils/utility.dart';

class AuthState extends ChangeNotifier{
  String _name = '';
  String _password = '';
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  LoginModel? _login;
  bool _isVisible = false;
  BuildContext? _context;
  bool _isVerifying = false;

  bool get isVerifying => _isVerifying;

  String get name => _name;

  String get password => _password;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  LoginModel get login => _login!;
  BuildContext get context => _context!;
  bool get isVisible => _isVisible;

  // Error messages
  String? _nameError;
  String? _passwordError;

  String? get nameError => _nameError;

  String? get passwordError => _passwordError;
  RegistrationData? _registrationData;
  RegistrationData? get registrationData => _registrationData;
  void setRegistrationData(RegistrationData data){
    _registrationData = data;
    notifyListeners();
  }

  void setName(String value) {
    _name = value;
    _validateName();
    notifyListeners();
  }
  void setIsOTPVerify(bool isVerifying){
    _isVerifying = isVerifying;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _validatePassword();
    notifyListeners();
  }


  void show() {
    _isVisible = true;
    notifyListeners();
  }

  void hide() {
    _isVisible = false;
    notifyListeners();
  }

  void setIsLoading(bool isLoading){
    _isLoading = isLoading;
    notifyListeners();
  }

  void setLoginData(LoginModel login){
    _login = login;
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

  void _validatePassword() {
    if (_password.isEmpty) {
      _passwordError = Strings.PASSWORD_REQUIRED_TXT;
    } else if (password.length < 8) {
      _passwordError = Strings.INVALID_PASSWORD;
    } else {
      _passwordError = null;
    }
  }

  bool get isValid {
    return _nameError == null && _passwordError == null;
  }

  void loginData(BuildContext context, String name, String password) {
    setName(name);
    setPassword(password);
    setContext(context);

    if (isValid) {
      Utils.printLog('Registering user with email: $name, password: $password');
    } else {
      Utils.printLog('Registration failed. Please correct the errors.');
    }
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  BusinessModel? _businessModel;
  BusinessModel? get businessModel => _businessModel;

  void setBusinessDetails(BusinessModel? data){
    _businessModel = data;
    notifyListeners();
  }
   final List<SocialMediaModel> _socialMediaList = [];
   List<SocialMediaModel> get socialMediaList => _socialMediaList;

   void setSocialMedia(SocialMediaModel data){
     _socialMediaList.add(data);
     notifyListeners();
   }
   void removeSocialMedia(SocialMediaModel data){
     _socialMediaList.remove(data);
     notifyListeners();
   }
   /// Payment Type ///

  CardDetails? _cardDetails;
  CardDetails? get cardDetails => _cardDetails;
  void setCardDetails(CardDetails details){
    _cardDetails = details;
    notifyListeners();
  }
  void removeCard(){
    _cardDetails = null;
    notifyListeners();
  }
  BankDetailsModel? _bankDetails;
  BankDetailsModel? get bankDetails => _bankDetails;
  void setBankDetails(BankDetailsModel details){
    _bankDetails = details;
    notifyListeners();
  }

  PaymentGatewayModel? _gateway;

  PaymentGatewayModel? get gateway => _gateway;

  void setGateway(PaymentGatewayModel data) {
    _gateway = data;
    notifyListeners();
  }

  void clearGateway() {
    _gateway = null;
    notifyListeners();
  }
}
