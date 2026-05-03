
import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../auth/model/payment_type_model.dart';
import '../auth/model/plan_model.dart';
import '../auth/model/social_media_model.dart';
import '../constants/string_utils.dart';
import '../models/login_model.dart';
import '../models/registration_data.dart';
import '../utils/sharedpreference_utils.dart';
import '../utils/utility.dart';

class AuthState extends ChangeNotifier{
  String _name = '';
  String _password = '';
  String _email = '';
  int _userID = 0;
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
  String _bankName = '';
  String _accountHolder = '';
  String _iban = '';
  String _bic = '';

  String? _bankNameError;
  String? _accountHolderError;
  String? _ibanError;
  String? _bicError;

  bool _showBankErrors = false;

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
  int get userId => _userID;
  String? get bankNameError => _bankNameError;
  String? get accountHolderError => _accountHolderError;
  String? get ibanError => _ibanError;
  String? get bicError => _bicError;

  String get bankName => _bankName;
  String get accountHolder => _accountHolder;
  String get iban => _iban;
  String get bic => _bic;

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
  void setUserId(int value){
    _userID = value;
    notifyListeners();
  }
  void loadUserId() async{
    if(_userID==0){
      _userID = (await SharedPreferenceUtils.getIntValuesSF(Strings.USER_ID))!;
      Utils.printLog("userid====$_userID");
    }
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
  ContactAndRegistrationDetails? _registrationDetailsData;
  ContactAndRegistrationDetails? get registrationDetailsData => _registrationDetailsData;

  void setRegistrationDetails(ContactAndRegistrationDetails? register){
    _registrationDetailsData = register;
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

  void setBankName(String value) {
    _bankName = value;

    if (_showBankErrors) {
      _validateBankName();
    } else {
      _bankNameError = null;
    }

    notifyListeners();
  }

  void setAccountHolder(String value) {
    _accountHolder = value;

    if (_showBankErrors) {
      _validateAccountHolder();
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

  void setBic(String value) {
    _bic = value.toUpperCase();

    if (_showBankErrors) {
      _validateBIC();
    } else {
      _bicError = null;
    }

    notifyListeners();
  }

  void _validateBankName() {
    if (_bankName.isEmpty) {
      _bankNameError = 'Bank name is required';
    }
    else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(_bankName)) {
      _bankNameError = 'Only letters and spaces allowed';
    }
    else {
      _bankNameError = null;
    }
  }

  void _validateAccountHolder() {
    if (_accountHolder.isEmpty) {
      _accountHolderError = 'Account holder name is required';
    }
    else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(_accountHolder)) {
      _accountHolderError = 'Only letters and spaces allowed';
    }
    else {
      _accountHolderError = null;
    }
  }

  void _validateIBAN() {
    if (_iban.isEmpty) {
      _ibanError = 'IBAN is required';
    }
    else if (!RegExp(r'^AE[0-9]{2}[0-9]{3}[0-9]{16}$').hasMatch(_iban)) {
      _ibanError = 'Invalid UAE IBAN format';
    }
    else {
      _ibanError = null;
    }
  }

  void _validateBIC() {
    if (_bic.isEmpty) {
      _bicError = 'BIC is required';
    }
    else if (!RegExp(r'^[A-Z0-9]{8}([A-Z0-9]{3})?$').hasMatch(_bic)) {
      _bicError = 'BIC must be 8 or 11 characters';
    }
    else {
      _bicError = null;
    }
  }

  bool validateBankDetails() {
    _showBankErrors = true;

    _validateBankName();
    _validateAccountHolder();
    _validateIBAN();
    _validateBIC();

    notifyListeners();

    return _bankNameError == null &&
        _accountHolderError == null &&
        _ibanError == null &&
        _bicError == null;
  }

  void clearBankErrors() {
    _showBankErrors = false;
    _bankNameError = null;
    _accountHolderError = null;
    _ibanError = null;
    _bicError = null;
    notifyListeners();
  }


  @override
  void dispose() {
    _isDisposed = true;
    stopTimer();
    super.dispose();
  }
}
