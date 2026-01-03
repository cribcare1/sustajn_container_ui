import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sustajn_customer/auth/screens/bank_details_screen.dart';
import 'package:sustajn_customer/auth/screens/reset_password_screen.dart' show ResetPasswordScreen;
import 'package:sustajn_customer/notifier/signup_notifier.dart';
import 'package:sustajn_customer/utils/nav_utils.dart' show NavUtil;

import '../auth/dashboard_screen/dashboard_screen.dart';
import '../auth/dashboard_screen/home_screen.dart';
import '../auth/payment_type/payment_screen.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/verify_email_screen.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../lottie_animations/account_create_animation.dart';
import '../models/login_model.dart';
import '../notifier/login_notifier.dart';
import '../service/login_service.dart';
import '../utils/shared_preference_utils.dart';
import '../utils/utils.dart';

final signUpNotifier = ChangeNotifierProvider((ref) => SignupNotifier());


final loginDetailProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(signUpNotifier);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.LOGIN_API}';
  var responseData = LoginModel();
  try {
    responseData = await apiService.loginUser(url, params, "");
    if (responseData.data!.userName != null) {
      registrationState.setIsLoading(false);
      registrationState.setLoginData(responseData);
      if(registrationState.context.mounted) {
        showCustomSnackBar(context: registrationState.context,
            message: Strings.LOGGED_SUCCESS, color:Colors.green);
      }

      String json = jsonEncode(responseData.toJson());
      SharedPreferenceUtils.saveDataInSF(
          Strings.JWT_TOKEN, responseData.data!.jwtToken!);
      SharedPreferenceUtils.saveDataInSF(Strings.IS_LOGGED_IN, true);
      SharedPreferenceUtils.saveDataInSF(Strings.PROFILE_DATA, json);
      SharedPreferenceUtils.saveDataInSF(
          Strings.USER_ID, responseData.data!.userId);
      if(registrationState.context.mounted){
        Navigator.pushReplacement(
          registrationState.context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    } else {
      if(registrationState.context.mounted){
        showCustomSnackBar(context: registrationState.context,
            message: "Login failed or response is not success", color:Colors.red);
      }

      registrationState.setIsLoading(false);
      Utils.printLog('Login failed or response is not success');
    }
  } catch (e) {
    registrationState.setIsLoading(false);
    if(registrationState.context.mounted){
      Utils.showNetworkErrorToast(registrationState.context, e.toString());}
  }finally{
    registrationState.setIsLoading(false);
  }
  return responseData;
});

///Register
final registerProvider = FutureProvider.family<dynamic, Map<String, dynamic>>(
      (ref, params) async {
    final registrationState = ref.watch(signUpNotifier);
    try {
      var serviceProvider = ref.read(loginApiProvider);
      var partUrl = params[Strings.PART_URL];
      var data = params[Strings.DATA];
      var requestKey = params[Strings.REQUEST_KEY];
      var image = params[Strings.IMAGE];
      Utils.printLog("partUrl===$partUrl");
      var responseData = await serviceProvider.registerUser(partUrl, data, requestKey, image);
      if (responseData.status != null && responseData.status!.isNotEmpty) {
        registrationState.setIsLoading(false);
        if(registrationState.context.mounted) {
          showCustomSnackBar(context: registrationState.context,
              message: 'Account created successfully', color:Colors.green);
        }
        NavUtil.navigateWithReplacement(
            AccountSuccessScreen());
      }else{
        Utils.showToast(responseData.message!);
      }
    } catch (e) {
      Utils.printLog("Register provider error called: $e");
      registrationState.setIsLoading(false);
      Utils.showNetworkErrorToast(registrationState.context, e.toString());
    }
  },
);



final forgotPasswordProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(signUpNotifier);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.FORGOT_PASSWORD}';
  try {
    var   responseData = await apiService.forgetPassword(url, params, "");
    final status = responseData['status'];
    final message = responseData['message'];

    if (status != null && status.isNotEmpty  && status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
      registrationState.setIsLoading(false);
      if(!registrationState.context.mounted) return;
      showCustomSnackBar(context: registrationState.context,
          message: responseData.message!, color:Colors.green);
      Utils.navigateToPushScreen(registrationState.context, VerifyEmailScreen(previousScreen: 'forgotPassword'));
    } else {
      if(!registrationState.context.mounted) return;
      showCustomSnackBar(context: registrationState.context,
          message: responseData.message!, color:Colors.red);
      registrationState.setIsLoading(false);
    }
  } catch (e) {
    registrationState.setIsLoading(false);
    Utils.showNetworkErrorToast(registrationState.context, e.toString());
  }finally{
    registrationState.setIsLoading(false);
  }
  return null;
});

final getOtpToVerifyProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(signUpNotifier);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.GET_OTP}';
  try {
    var   responseData = await apiService.verifyOtp(url, params, "");

    final status = responseData['status'];
    final message = responseData['message'];

    if (status != null && status.isNotEmpty  && status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
      registrationState.setIsLoading(false);
      registrationState.setSeconds(120);
      registrationState.startTimer();
      showCustomSnackBar(
        context: registrationState.context,
        message: responseData["message"],
        color: Colors.green,
      );
      if(!registrationState.isResend) {
        Utils.navigateToPushScreen(
            registrationState.context, VerifyEmailScreen(previousScreen: ''));
      }else{
        registrationState.setResend(false);
      }
    } else {
      registrationState.setSeconds(120);
      registrationState.startTimer();
      if(!registrationState.context.mounted) return;
      showCustomSnackBar(context: registrationState.context,
          message: message!, color:Colors.black);
      registrationState.setIsLoading(false);
    }
  } catch (e) {
    registrationState.setSeconds(60);
    registrationState.startTimer();
    registrationState.setIsLoading(false);
    Utils.showNetworkErrorToast(registrationState.context, e.toString());
  }finally{
    registrationState.setIsLoading(false);
  }
  return null;
});

final verifyOtpProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(signUpNotifier);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.VERIFY_OTP}';
  try {
    var   responseData = await apiService.verifyOtp(url, params, "");

    final status = responseData['status'];
    final message = responseData['message'];

    if (status != null && status.isNotEmpty  && status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
      registrationState.setIsLoading(false);
      showCustomSnackBar(
        context: registrationState.context,
        message: message ?? "OTP verified successfully",
        color: Colors.green,
      );
      if(registrationState.isForgotPassword){
        Utils.navigateToPushScreen(registrationState.context, ResetPasswordScreen());
      }else {
        Utils.navigateToPushScreen(registrationState.context, PaymentTypeScreen());
      }
    } else {
      if(!registrationState.context.mounted) return;
      showCustomSnackBar(context: registrationState.context,
          message: message!, color:Colors.black);
      registrationState.setIsLoading(false);
    }
  } catch (e) {
    registrationState.setIsLoading(false);
    Utils.showNetworkErrorToast(registrationState.context, e.toString());
  }finally{
    registrationState.setIsLoading(false);
  }
  return null;
});

final resetPasswordProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(signUpNotifier);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.RESET_PASSWORD}';
  try {
    var   responseData = await apiService.resetPassword(url, params, "");

    final status = responseData['status'];
    final message = responseData['message'];

    if (status != null && status.isNotEmpty  && status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
      registrationState.setIsLoading(false);
      showCustomSnackBar(
        context: registrationState.context,
        message: message ?? "Password reset successfully",
        color: Colors.green,
      );
      NavUtil.navigationToWithReplacement(
          registrationState.context, LoginScreen());
    } else {
      if(!registrationState.context.mounted) return;
      showCustomSnackBar(context: registrationState.context,
          message: message!, color:Colors.black);
      registrationState.setIsLoading(false);
    }
  } catch (e) {
    registrationState.setIsLoading(false);
    Utils.showNetworkErrorToast(registrationState.context, e.toString());
  }finally{
    registrationState.setIsLoading(false);
  }
  return null;
});