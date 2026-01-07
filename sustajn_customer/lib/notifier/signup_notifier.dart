import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../constants/string_utils.dart';
import '../models/login_model.dart';
import '../models/register_data.dart';
import '../models/subscriptionplan_data.dart';

import '../utils/utils.dart';

class SignupNotifier extends ChangeNotifier{
  String _name = '';
  String _password = '';
  String _email = '';
  String _otp = '';
  bool _isResend = false;
  bool _isForgotPassword = false;
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isTimerRunning = false;
  LoginModel? _login;
  bool _isVisible = false;
  bool _isDisposed = false;
  int _seconds = 120;
  BuildContext? _context;
  File? _image;
  String _bankName = '';
  String _accountHolderName = '';
  String _iban = '';
  String _bic = '';
  String? _bankNameError;
  String? _accountHolderError;
  String? _ibanError;
  String? _bicError;
  RegistrationData? _registrationData;
  SubscriptionModel? _subscriptionModel;
  List<SubscriptionData>? data = [];



  String get name => _name;
  String get email => _email;
  String get otp => _otp;
  String get password => _password;
  int get seconds => _seconds;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isLoading => _isLoading;
  bool get isForgotPassword => _isForgotPassword;
  bool get isResend => _isResend;
  LoginModel get login => _login!;
  BuildContext get context => _context!;
  bool get isVisible => _isVisible;
  File? get image => _image;
  String? get bankNameError => _bankNameError;
  String? get accountHolderError => _accountHolderError;
  String? get ibanError => _ibanError;
  String? get bicError => _bicError;

  RegistrationData? get registrationData => _registrationData;
  SubscriptionModel? get subscriptionModel => _subscriptionModel;
  List<SubscriptionData>? get subscriptionList=> data;



  // Error messages
  String? _nameError;
  String? _passwordError;

  String? get nameError => _nameError;

  String? get passwordError => _passwordError;
  void setRegistrationData(RegistrationData registrationData){
    _registrationData = registrationData;
    notifyListeners();
  }
  void setSubscriptionModel(SubscriptionModel subscriptionModel){
    _subscriptionModel = subscriptionModel;
    data = subscriptionModel.data;
    notifyListeners();
  }
  void setSeconds(int value){
    _seconds = value;
    notifyListeners();
  }
  void setName(String value) {
    _name = value;
    _validateName();
    notifyListeners();
  }

  void setSubscriptionPlan(int planId) {
    if (_registrationData == null) return;

    _registrationData!.subscriptionPlanId = planId;
    notifyListeners();
  }


  void setBankName(String value) {
    _bankName = value;
    if (_bankName.isEmpty) {
      _bankNameError = 'Bank name is required';
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(_bankName)) {
      _bankNameError = 'Special characters are not allowed';
    } else {
      _bankNameError = null;
    }
    notifyListeners();
  }

  void setAccountHolderName(String value) {
    _accountHolderName = value;
    if (_accountHolderName.isEmpty) {
      _accountHolderError = 'Account holder name is required';
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(_accountHolderName)) {
      _accountHolderError = 'Special characters are not allowed';
    } else {
      _accountHolderError = null;
    }
    notifyListeners();
  }

  void setIban(String value) {
    _iban = value.toUpperCase();
    if (_iban.isEmpty) {
      _ibanError = 'IBAN is required';
    } else if (!RegExp(r'^[A-Z0-9]+$').hasMatch(_iban)) {
      _ibanError = 'Only letters and numbers allowed';
    } else if (_iban.length < 15 || _iban.length > 34) {
      _ibanError = 'IBAN must be 15–34 characters';
    } else {
      _ibanError = null;
    }
    notifyListeners();
  }

  void setBic(String value) {
    _bic = value.toUpperCase();
    if (_bic.isEmpty) {
      _bicError = 'BIC is required';
    } else if (!RegExp(r'^[A-Z0-9]+$').hasMatch(_bic)) {
      _bicError = 'Only letters and numbers allowed';
    } else if (_bic.length != 8 && _bic.length != 11) {
      _bicError = 'BIC must be 8 or 11 characters';
    } else {
      _bicError = null;
    }
    notifyListeners();
  }

  void setAddress({
    required String address,
    String? postalCode,
    required double latitude,
    required double longitude,
  }) {
    if (_registrationData == null) {
      _registrationData = RegistrationData();
    }

    _registrationData!
      ..areaStreetCityBlockDetails = address
      ..poBoxOrPostalCode = postalCode
      ..latitude = latitude
      ..longitude = longitude;

    notifyListeners();
  }



  void setIsForgotPassword(var value){
    _isForgotPassword = value;
    notifyListeners();
  }
  void setResend(var value){
    _isResend = value;
    notifyListeners();
  }
  void setPassword(String value) {
    _password = value;
    _validatePassword();
    notifyListeners();
  }

  void setContext(BuildContext context){
    _context = context;
    notifyListeners();
  }
  void show() {
    _isVisible = true;
    notifyListeners();
  }

  void setEmail(String value){
    _email = value;
    notifyListeners();
  }

  void setToken(String value){
    _otp = value;
    notifyListeners();
  }

  void setImage(File? file){
    _image = file;
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

  bool get isBankFormValid {
    return _bankNameError == null &&
        _accountHolderError == null &&
        _ibanError == null &&
        _bicError == null &&
        _bankName.isNotEmpty &&
        _accountHolderName.isNotEmpty &&
        _iban.isNotEmpty &&
        _bic.isNotEmpty;
  }

  void updateBankDetails() {
    if (_registrationData == null) return;

    _registrationData!
      ..bankName = _bankName
      ..accountHolderName = _accountHolderName
      ..iban = _iban
      ..bic = _bic;

    notifyListeners();
  }

  bool validateBankForm() {
    setBankName(_bankName);
    setAccountHolderName(_accountHolderName);
    setIban(_iban);
    setBic(_bic);

    return isBankFormValid;
  }




  void startTimer() {
    if (_isTimerRunning) return;
    _isTimerRunning = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (_isDisposed) {
        _isTimerRunning = false;
        return false;
      }

      if (_seconds > 0) {
        _seconds--;
        notifyListeners();
        return true;
      }
      _isTimerRunning = false;
      return false;
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

}