import 'dart:async';
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
  bool _isVerifyLoading = false;
  bool _isResendLoading = false;
  bool _isTimerRunning = false;
  LoginModel? _login;
  bool _isVisible = false;
  bool _isDisposed = false;
  int _seconds = 120;
  Timer? _otpTimer;
  bool _hasActiveListeners = false;


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
  bool _showBankErrors = false;



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

  bool get isVerifyLoading => _isVerifyLoading;
  bool get isResendLoading => _isResendLoading;
  File? get image => _image;
  String? get bankNameError => _bankNameError;
  String? get accountHolderError => _accountHolderError;
  String? get ibanError => _ibanError;
  String? get bicError => _bicError;
  bool get showBankErrors => _showBankErrors;

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

  void resetTimer({int startFrom = 120}) {
    stopTimer();
    _seconds = startFrom;
    _safeNotify();
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

  void _validateBankName() {
    if (_bankName.isEmpty) {
      _bankNameError = 'Bank name is required';
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(_bankName)) {
      _bankNameError = 'Special characters are not allowed';
    } else {
      _bankNameError = null;
    }
  }

  void setBankName(String value) {
    _bankName = value;

    if (_showBankErrors) {
      _validateBankName();
    } else {
      _bankNameError = null;
    }

    notifyListeners();
  }


  void _validateAccHolderName(){
    if (_accountHolderName.isEmpty) {
      _accountHolderError = 'Account holder name is required';
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(_accountHolderName)) {
      _accountHolderError = 'Special characters are not allowed';
    } else {
      _accountHolderError = null;
    }
  }
  void setAccountHolderName(String value) {
    _accountHolderName = value;
    if (_showBankErrors) {
      _validateAccHolderName();
    } else {
      _accountHolderError = null;
    }
    notifyListeners();
  }


  void setIban(String value) {
    _iban = value.toUpperCase();
    if (_showBankErrors) {
      _validateIBAN();
    } else {
      _ibanError = null;
    }
    notifyListeners();
  }


  void _validateIBAN(){
    if (_iban.isEmpty) {
      _ibanError = 'IBAN is required';
    } else if (!RegExp(r'^[A-Z0-9]+$').hasMatch(_iban)) {
      _ibanError = 'Only letters and numbers allowed';
    } else if (_iban.length < 15 || _iban.length > 34) {
      _ibanError = 'IBAN must be 15–34 characters';
    } else {
      _ibanError = null;
    }
  }

  void setBic(String value) {
    _bic = value.toUpperCase();
    if (_showBankErrors) {
      _validateBIC();
    } else {
      _bicError = null;
    }
    notifyListeners();
  }


  void _validateBIC(){
    if (_bic.isEmpty) {
      _bicError = 'BIC is required';
    } else if (!RegExp(r'^[A-Z0-9]+$').hasMatch(_bic)) {
      _bicError = 'Only letters and numbers allowed';
    } else if (_bic.length != 8 && _bic.length != 11) {
      _bicError = 'BIC must be 8 or 11 characters';
    } else {
      _bicError = null;
    }
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


  void setVerifyLoading(bool value) {
    _isVerifyLoading = value;
    notifyListeners();
  }

  void setResendLoading(bool value) {
    _isResendLoading = value;
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
    return _bankName.isNotEmpty &&
        _accountHolderName.isNotEmpty &&
        _iban.isNotEmpty &&
        _bic.isNotEmpty &&
        _bankNameError == null &&
        _accountHolderError == null &&
        _ibanError == null &&
        _bicError == null;
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
    _showBankErrors = true;

    _validateBankName();
    _validateAccHolderName();
    _validateIBAN();
    _validateBIC();

    notifyListeners();

    return _bankNameError == null &&
        _accountHolderError == null &&
        _ibanError == null &&
        _bicError == null;
  }


  void resetBankValidation() {
    _showBankErrors = false;
    _bankNameError = null;
    _accountHolderError = null;
    _ibanError = null;
    _bicError = null;
    notifyListeners();
  }

  void startTimer() {
    if (_isTimerRunning) return;

    _isTimerRunning = true;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        _seconds--;
        _safeNotify();
      } else {
        stopTimer();
      }
    });
  }



  void stopTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
    _isTimerRunning = false;
  }



  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void addListener(VoidCallback listener) {
    _hasActiveListeners = true;
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    _hasActiveListeners = hasListeners;
  }

  void _safeNotify() {
    if (_hasActiveListeners) {
      notifyListeners();
    }
  }


}