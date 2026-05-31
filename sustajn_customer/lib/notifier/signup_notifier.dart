import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../constants/string_utils.dart';
import '../models/login_model.dart';
import '../models/register_data.dart';
import '../models/signup_model.dart';
import '../models/subscriptionplan_data.dart';

import '../utils/utils.dart';

class SignupNotifier extends ChangeNotifier {
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
  SignUpModel? _signUp;
  bool _isVisible = false;
  bool _isDisposed = false;
  int _seconds = 120;
  Timer? _otpTimer;
  RegistrationData? _registrationData;
  SubscriptionModel? _subscriptionModel;
  List<SubscriptionData>? data = [];


  BuildContext? _context;
  File? _image;
  String _bankName = '';
  String _accountHolderName = '';
  String _iban = '';
  String _bic = '';
  String _taxNumber = '';
  String _accountNumber = '';
  String _cardHolderName = '';
  String _cardNumber = '';
  String _cvv = '';
  String _expiryDate = '';
  String _upiId = '';
  String _paymentGatewayId = '';
  String _paymentGatewayName = '';


  String? _bankNameError;
  String? _accountHolderError;
  String? _taxNumberError;
  String? _accountNumberError;
  String? _ibanError;
  String? _bicError;
  String? _cardHolderError;
  String? _cardNumberError;
  String? _cvvError;
  String? _expiryError;
  String? _upiError;
  String? _paymentError;


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
  String get cardHolderName => _cardHolderName;
  String get cardNumber => _cardNumber;
  String get cvv => _cvv;
  String get expiryDate => _expiryDate;
  String get upiId => _upiId;

  LoginModel get login => _login!;
  SignUpModel get signup => _signUp!;
  PaymentMethodType? _paymentMethod;
  String? get paymentMethod => _paymentMethod?.name;
  String get paymentGatewayId => _paymentGatewayId;
  String get paymentGatewayName => _paymentGatewayName;


  BuildContext get context => _context!;

  bool get isVisible => _isVisible;

  bool get isVerifyLoading => _isVerifyLoading;

  bool get isResendLoading => _isResendLoading;

  File? get image => _image;

  String? get bankNameError => _bankNameError;

  String? get accountHolderError => _accountHolderError;

  String? get taxNumberError => _taxNumberError;

  String? get accountNumberError => _accountNumberError;

  String? get ibanError => _ibanError;

  String? get bicError => _bicError;
  String? get upiError => _upiError;
  String? get paymentError => _paymentError;

  bool get showBankErrors => _showBankErrors;
  String? get cardHolderError => _cardHolderError;
  String? get cardNumberError => _cardNumberError;
  String? get cvvError => _cvvError;
  String? get expiryError => _expiryError;

  RegistrationData? get registrationData => _registrationData;

  SubscriptionModel? get subscriptionModel => _subscriptionModel;

  List<SubscriptionData>? get subscriptionList => data;


  // Error messages
  String? _nameError;
  String? _passwordError;

  String? get nameError => _nameError;

  String? get passwordError => _passwordError;

  void setRegistrationData(RegistrationData registrationData) {
    _registrationData = registrationData;
    notifyListeners();
  }

  void setSubscriptionModel(SubscriptionModel subscriptionModel) {
    _subscriptionModel = subscriptionModel;
    data = subscriptionModel.data;
    notifyListeners();
  }

  void setSeconds(int value) {
    _seconds = value;
    notifyListeners();
  }

  void resetTimer({int startFrom = 120}) {
    stopTimer();
    _seconds = startFrom;
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
      _bankNameError = 'Only letters and numbers allowed';
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



  void setIban(String value) {
    _iban = value.toUpperCase();
    if (_showBankErrors) {
      _validateIBAN();
    } else {
      _ibanError = null;
    }
    notifyListeners();
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



  void setBic(String value) {
    _bic = value.toUpperCase();

    if (_showBankErrors) {
      _validateBIC();
    } else {
      _bicError = null;
    }

    notifyListeners();
  }

  void setUpiId(String value) {
    _upiId = value;
    _upiError = null;
    notifyListeners();
  }

  void updateUpiDetails({
    required String gatewayId,
    required String gatewayName,
  }) {
    _registrationData ??= RegistrationData();

    if (gatewayId.isEmpty) {
      _paymentMethod = null;
      _paymentGatewayId = '';
      _paymentGatewayName = '';
      _paymentError = null;

      notifyListeners();
      return;
    }

    _paymentMethod = PaymentMethodType.upi;

    _paymentGatewayId = gatewayId;
    _paymentGatewayName = gatewayName;

    _registrationData!
      ..paymentMethod = "UPI"
      ..paymentGatewayId = gatewayId
      ..paymentGatewayName = gatewayName;

    notifyListeners();
  }

  void validatePaymentGateWayId(paymentGatewayName){
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if(_paymentGatewayId.isEmpty){
      _paymentError = "Payment ID is required";
    }

    switch(paymentGatewayName){
      case Strings.PAYPAL:
        if (!emailRegex.hasMatch(_bic)) {
          _paymentError = 'Enter a valid Paypal ID';
        }
        break;
      case Strings.GOOGLE:
        final upiRegex = RegExp(r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z]{2,64}$');
        if (!upiRegex.hasMatch(_bic)) {
          _paymentError = 'Enter a valid Google Pay UPI ID';
        }
        break;
      case Strings.APPLE:
         _paymentError = null;
        break;
      default:
        _paymentError = null;
        break;
    }
  }

  void _validateBIC() {
    if (_bic.isEmpty) {
      _bicError = 'BIC is required';
    }
    else if (!RegExp(r'^[A-Z0-9]{8}([A-Z0-9]{3})?$').hasMatch(_bic)) {
      _bicError = 'BIC must be 8 or 11 alphanumeric characters';
    }
    else {
      _bicError = null;
    }
  }



  void setAccountHolderName(String value) {
    _accountHolderName = value;

    if (_showBankErrors) {
      _validateAccountHolderName();
    } else {
      _accountHolderError = null;
    }

    notifyListeners();
  }

  void _validateAccountHolderName() {
    if (_accountHolderName.isEmpty) {
      _accountHolderError = 'Account holder name is required';
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(_accountHolderName)) {
      _accountHolderError = 'Only letters and spaces allowed';
    } else {
      _accountHolderError = null;
    }
  }


  void setTaxNumber(String value) {
    _taxNumber = value.toUpperCase();

    if (_showBankErrors) {
      _validateTaxNumber();
    } else {
      _taxNumberError = null;
    }
    notifyListeners();
  }


  void _validateTaxNumber() {
    if (_taxNumber.isEmpty) {
      _taxNumberError = 'Tax number is required';
    }
    else if (!RegExp(r'^[A-Z0-9]+$').hasMatch(_taxNumber)) {
      _taxNumberError = 'Only letters and numbers allowed';
    }
    else if (_taxNumber.length != 15) {
      _taxNumberError = 'Tax number must be exactly 15 characters';
    }
    else {
      _taxNumberError = null;
    }
  }


  void setAccountNumber(String value) {
    _accountNumber = value;

    if (_showBankErrors) {
      _validateAccountNumber();
    } else {
      _accountNumberError = null;
    }
    notifyListeners();
  }

  void _validateAccountNumber() {
    if (_accountNumber.isEmpty) {
      _accountNumberError = 'Account number is required';
    } else if (!RegExp(r'^[0-9]{9,18}$').hasMatch(_accountNumber)) {
      _accountNumberError = 'Account number must be 9–18 digits';
    } else {
      _accountNumberError = null;
    }
  }

  void setCardHolderName(String value) {
    _cardHolderName = value;

    if (_showBankErrors) {
      _validateCardHolder();
    } else {
      _cardHolderError = null;
    }
    notifyListeners();
  }

  void _validateCardHolder() {
    if (_cardHolderName.isEmpty) {
      _cardHolderError = 'Card holder name is required';
    } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(_cardHolderName)) {
      _cardHolderError = 'Only letters and spaces allowed';
    } else {
      _cardHolderError = null;
    }
  }

  void setCardNumber(String value) {
    _cardNumber = value;

    if (_showBankErrors) {
      _validateCardNumber();
    } else {
      _cardNumberError = null;
    }
    notifyListeners();
  }

  void _validateCardNumber() {
    if (_cardNumber.isEmpty) {
      _cardNumberError = 'Card number is required';
    } else if (!RegExp(r'^[0-9]{16}$').hasMatch(_cardNumber)) {
      _cardNumberError = 'Card number must be 16 digits';
    } else {
      _cardNumberError = null;
    }
  }

  void setCVV(String value) {
    _cvv = value;

    if (_showBankErrors) {
      _validateCVV();
    } else {
      _cvvError = null;
    }
    notifyListeners();
  }

  void _validateCVV() {
    if (_cvv.isEmpty) {
      _cvvError = 'CVV is required';
    } else if (!RegExp(r'^[0-9]{4}$').hasMatch(_cvv)) {
      _cvvError = 'CVV must be 4 digits';
    } else {
      _cvvError = null;
    }
  }

  void setExpiryDate(String value) {
    _expiryDate = value;
    _expiryError = null;
    notifyListeners();
  }

  bool validateCardForm() {
    _showBankErrors = true;

    _validateCardHolder();
    _validateCardNumber();
    _validateCVV();

    notifyListeners();

    return _cardHolderError == null &&
        _cardNumberError == null &&
        _cvvError == null;
  }

  void resetCardValidation() {
    _showBankErrors = false;

    _cardHolderName = '';
    _cardNumber = '';
    _cvv = '';
    _expiryDate = '';

    _cardHolderError = null;
    _cardNumberError = null;
    _cvvError = null;
    _expiryError = null;

    notifyListeners();
  }



  void setAddress({
    required String addressType,
    required String flatDoorHouseDetails,
    required String areaStreetCityBlockDetails,
    required String poBoxOrPostalCode,
    required double latitude,
    required double longitude,
  }) {
    _registrationData ??= RegistrationData();

    _registrationData!
      ..addressType = addressType
      ..flatDoorHouseDetails = flatDoorHouseDetails
      ..areaStreetCityBlockDetails = areaStreetCityBlockDetails
      ..poBoxOrPostalCode = poBoxOrPostalCode
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

  void setSignUPData(SignUpModel signup){
    _signUp = signup;
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
    _registrationData ??= RegistrationData();

    _paymentMethod = PaymentMethodType.bank;
    //_clearOtherPaymentData(PaymentMethodType.bank);

    _registrationData!
      ..paymentMethod = "BANK"
      ..bankName = _bankName
      ..accountHolderName = _accountHolderName
      ..iban = _iban
      ..bic = _bic;

    notifyListeners();
  }


  void updateCardDetails() {
    _registrationData ??= RegistrationData();

    _paymentMethod = PaymentMethodType.card;
    //_clearOtherPaymentData(PaymentMethodType.card);

    _registrationData!
      ..paymentMethod = "CARD"
      ..cardHolderName = _cardHolderName
      ..cardNumber = _cardNumber
      ..expiryDate = _expiryDate
      ..cvv = _cvv;

    notifyListeners();
  }





  bool validatePaymentDetails() {
    _showBankErrors = true;

    switch (_paymentMethod) {
      case PaymentMethodType.bank:
        _validateBankName();
        _validateAccountHolderName();
        _validateBIC();
        _validateIBAN();

        notifyListeners();

        return _bankNameError == null &&
            _accountHolderError == null &&
            _bicError == null &&
            _ibanError == null;

      case PaymentMethodType.card:
        _validateCardHolder();
        _validateCardNumber();
        _validateCVV();

        notifyListeners();

        return _cardHolderError == null &&
            _cardNumberError == null &&
            _cvvError == null;

      case PaymentMethodType.upi:
        validatePaymentGateWayId(_paymentGatewayName);

        notifyListeners();

        return _paymentError == null;

      default:
        return false;
    }
  }

  bool validateBankForm() {
    _showBankErrors = true;

    _validateBankName();
    _validateAccountHolderName();
    _validateBIC();
    _validateIBAN();

    notifyListeners();

    return _bankNameError == null &&
        _accountHolderError == null &&
        _bicError == null &&
        _ibanError == null;
  }


  void resetBankValidation() {
    _showBankErrors = false;

    _bankName = '';
    _accountHolderName = '';
    _iban = '';
    _bic = '';

    _bankNameError = null;
    _accountHolderError = null;
    _ibanError = null;
    _bicError = null;

    notifyListeners();
  }


  void startTimer() {
    if (_isTimerRunning) return;   // prevent duplicates

    _isTimerRunning = true;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isDisposed || !_isTimerRunning) {
        timer.cancel();
        return;
      }

      if (_seconds > 0) {
        _seconds--;
        notifyListeners();
      } else {
        stopTimer();
      }
    });
  }

  void _clearOtherPaymentData(PaymentMethodType selected) {
    if (selected != PaymentMethodType.bank) {
      _bankName = '';
      _accountHolderName = '';
      _iban = '';
      _bic = '';
    }

    if (selected != PaymentMethodType.card) {
      _cardHolderName = '';
      _cardNumber = '';
      _cvv = '';
      _expiryDate = '';
    }

    if (selected != PaymentMethodType.upi) {
      _upiId = '';
    }
  }






  void stopTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
    _isTimerRunning = false;
  }

  void resetOtpScreen() {
    stopTimer();
    _seconds = 120;
    _isVerifyLoading = false;
    _isResendLoading = false;
    _isResend = false;
    notifyListeners();
  }



  @override
  void dispose() {
    _isDisposed = true;
    stopTimer();
    super.dispose();
  }
}