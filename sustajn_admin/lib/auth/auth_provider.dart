import 'dart:convert';

import 'package:container_tracking/auth/auth_state.dart';
import 'package:container_tracking/auth/screens/bottom_navigation_bar/bottom_navigation_bar.dart';
import 'package:container_tracking/auth/screens/login_screen.dart';
import 'package:container_tracking/auth/screens/reset_password_screen.dart';
import 'package:container_tracking/auth/screens/verify_email_screen.dart';
import 'package:container_tracking/constants/network_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../constants/string_utils.dart';
import '../utils/SharedPreferenceUtils.dart';
import '../utils/utility.dart';
import 'auth_services/auth_services.dart';
import 'model/login_model.dart';

final authNotifierProvider = ChangeNotifierProvider((ref) => AuthState());


final loginDetailProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.LOGIN_API}';
  var responseData = LoginModel();
  try {
    responseData = await apiService.loginUser(url, params, "");
     if (responseData.userName != null) {
      registrationState.setIsLoading(false);
      registrationState.setLoginData(responseData);
      if(registrationState.context.mounted) {
        showCustomSnackBar(context: registrationState.context,
            message: Strings.LOGGED_SUCCESS, color:Colors.green);
      }

      String json = jsonEncode(responseData.toJson());
      SharedPreferenceUtils.saveDataInSF(
          Strings.JWT_TOKEN, responseData.jwtToken!);
      SharedPreferenceUtils.saveDataInSF(Strings.IS_LOGGED_IN, true);
      SharedPreferenceUtils.saveDataInSF(Strings.PROFILE_DATA, json);
if(registrationState.context.mounted){
      Navigator.pushReplacement(
        registrationState.context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );}
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

final registerDetailProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.REGISTER_USER}';
  try {
 var   responseData = await apiService.registrationUser(url, params, "");
    if (responseData != null) {
      registrationState.setIsLoading(false);
      if(!registrationState.context.mounted) return;
      Navigator.pushReplacement(
            registrationState.context,
            MaterialPageRoute(
              builder: (_) => const VerifyEmailScreen(previousScreen: "signUp"),
            ),
          );
    } else {
      if(!registrationState.context.mounted) return;
      showCustomSnackBar(context: registrationState.context,
          message: "Response is not success", color:Colors.red);
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

final forgotPasswordProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.FORGOT_PASSWORD}';
  try {
 var   responseData = await apiService.forgetPassword(url, params, "");
    if (responseData != null) {
      registrationState.setIsLoading(false);
      if(!registrationState.context.mounted) return;
      showCustomSnackBar(context: registrationState.context,
          message: responseData.message!, color:Colors.green);
      Navigator.pushReplacement(
            registrationState.context,
            MaterialPageRoute(
              builder: (_) => const ResetPasswordScreen(),
            ),
          );
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

final verifyOtpProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.VERIFY_OTP}';
  try {
    var   responseData = await apiService.verifyOtp(url, params, "");
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      registrationState.setIsLoading(false);
      if(!registrationState.context.mounted) return;
      showCustomSnackBar(context: registrationState.context,
          message: responseData.message!, color:Colors.green);
      Navigator.pushReplacement(
        registrationState.context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
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
