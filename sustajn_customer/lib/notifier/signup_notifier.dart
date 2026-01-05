import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../constants/string_utils.dart';
import '../models/login_model.dart' hide Data;
import '../models/register_data.dart';
import '../models/subscriptionplan_data.dart';

import '../utils/utils.dart';

class SignupNotifier extends ChangeNotifier{
  String _name = '';
  String _password = '';
  String _email = '';
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
  RegistrationData? _registrationData;
  SubscriptionModel? _subscriptionModel;
  List<SubscriptionData>? data = [];



  String get name => _name;
  String get email => _email;
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
  // void setContext(BuildContext context) {
  //   _context = context;
  //   notifyListeners();
  // }

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

  // void startTimer() {
  //   Future.doWhile(() async {
  //     // final signUpState = ref.read(signUpNotifier);
  //     await Future.delayed(const Duration(seconds: 1));
  //     // if (!mounted) return false;
  //     if (seconds > 0) {
  //       setSeconds(seconds-1);
  //       notifyListeners();
  //       return true;
  //     }
  //     return false;
  //   });
  // }

  void startTimer() {
    if (_isTimerRunning) return; // 🚫 prevent multiple timers
    _isTimerRunning = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (_isDisposed) {
        _isTimerRunning = false;
        return false;
      }

      if (_seconds > 0) {
        _seconds--;
        notifyListeners(); // 🔥 THIS replaces setState
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