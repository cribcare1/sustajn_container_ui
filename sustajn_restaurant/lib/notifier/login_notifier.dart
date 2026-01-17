
import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../auth/model/payment_type_model.dart';
import '../auth/model/plan_model.dart';
import '../auth/model/social_media_model.dart';
import '../constants/string_utils.dart';
import '../models/login_model.dart';
import '../models/registration_data.dart';
import '../utils/utility.dart';

class AuthState extends ChangeNotifier{
  String _name = '';
  String _password = '';
  String _email = '';
  bool _isPasswordVisible = false;
  bool _isForgotPassword = false;
  bool _isLoading = false;
  bool _isVerifyLoading = false;
  bool _isResendLoading = false;
  LoginModel? _login;
  bool _isVisible = false;
  BuildContext? _context;
  bool _isVerifying = false;
  int _seconds = 120;
  Timer? _otpTimer;
  bool _isDisposed = false;

  bool get isVerifying => _isVerifying;

  String get name => _name;

  String get password => _password;

  bool get isPasswordVisible => _isPasswordVisible;
  bool get isVerifyLoading => _isVerifyLoading;
  bool get isResendLoading => _isResendLoading;
  bool get isLoading => _isLoading;
  LoginModel get login => _login!;
  int get seconds => _seconds;
  BuildContext get context => _context!;
  bool get isVisible => _isVisible;

  // Error messages
  String? _nameError;
  String? _passwordError;

  String? get nameError => _nameError;

  String? get passwordError => _passwordError;
  RegistrationData? _registrationData;
  RegistrationData? get registrationData => _registrationData;
  bool get isForgotPassword => _isForgotPassword;
  String get email => _email;
  void setRegistrationData(RegistrationData data){
    _registrationData = data;
    notifyListeners();
  }

  void setIsForgotPassword(var value){
    _isForgotPassword = value;
    notifyListeners();
  }
  void setEmail(String value){
    _email = value;
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

  void setVerifyLoading(bool value) {
    _isVerifyLoading = value;
    notifyListeners();
  }
  void setSeconds(int value){
    _seconds = value;
    notifyListeners();
  }

  void resetTimer({int startFrom = 120}) {
    stopTimer();
    _seconds = startFrom;
  }

  void startTimer() {
    stopTimer(); // prevent duplicate timers

    // _isTimerRunning = true;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (_seconds > 0) {
        _seconds--;
        notifyListeners(); // <-- THIS IS ENOUGH
      } else {
        stopTimer();
      }
    });
  }





  void stopTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
    // _isTimerRunning = false;
  }
  void setResendLoading(bool value) {
    _isResendLoading = value;
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

  /// Subscription ///

bool _isPlanLoading = false;
  List<PlanModel> _plans = [];
  int _planId = 0;
  int get planId => _planId;
bool get isPlanLoading  => _isPlanLoading;
  List<PlanModel> get plans => _plans;
  String? _planError;
  String? get planError => _planError;

  void setIsPlanLoading(bool isLoading){
    _isPlanLoading = isLoading;
    notifyListeners();
  }
  void setPlan(List<PlanModel> plan){
    _plans = plan;
    notifyListeners();
  }
  void setPlanId(int id){
    _planId = id;
    notifyListeners();
  }
  void setPlanError(String error){
    _planError = error;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    stopTimer();
    super.dispose();
  }
}
