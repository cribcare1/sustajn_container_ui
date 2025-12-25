import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sustajn_restaurant/auth/screens/login_screen.dart';
import 'package:sustajn_restaurant/auth/screens/verify_email_screen.dart';

import '../auth/screens/dashboard_screen.dart';
import '../auth/screens/reset_password.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../utils/sharedpreference_utils.dart';
import '../utils/utility.dart';
import '../service/login_service.dart';
import '../notifier/login_notifier.dart';
import '../auth/bottom_navigation_bar/bottom_navigation_bar.dart';
import '../models/login_model.dart';

final authNotifierProvider = ChangeNotifierProvider((ref) => AuthState());


final loginDetailProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);

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
      if(registrationState.context.mounted){
        Navigator.pushReplacement(
          registrationState.context,
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
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

final registerProvider = FutureProvider.family<dynamic, Map<String, dynamic>>(
      (ref, params) async {
    final registrationState = ref.watch(authNotifierProvider);
    try {
      var serviceProvider = ref.read(loginApiProvider);
      var partUrl = params[Strings.PART_URL];
      var data = params[Strings.DATA];
      var requestKey = params[Strings.REQUEST_KEY];
      var image = params[Strings.IMAGE];
      Utils.printLog("partUrl===$partUrl");
      var responseData = await serviceProvider.registerUser(partUrl, data, requestKey, image);
      if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status == Strings.SUCCESS) {
        registrationState.setIsLoading(false);
        if(registrationState.context.mounted) {
          showCustomSnackBar(context: registrationState.context,
              message: Strings.USER_REGISTERED_SUCCESS, color:Colors.green);
        }
        Utils.navigateToPushScreen(registrationState.context,
            LoginScreen());
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

final validateEmail = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    args,
    ) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);
  final String email = args['email'];
  final String previous = args['previous'];
  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.FORGOT_PASSWORD}';
  try {
    final responseData = await apiService.forgetPassword(url, {
      "email": email,
    }, "");
    if (responseData != null && responseData.isNotEmpty) {
      if (!registrationState.context.mounted) return null;
      showCustomSnackBar(
        context: registrationState.context,
        message: responseData["message"],
        color: Colors.green,
      );
      Navigator.pushReplacement(
        registrationState.context,
        MaterialPageRoute(
          builder: (_) =>
              VerifyEmailScreen(previousScreen: previous, email: email),
        ),
      );
    } else {
      if (!registrationState.context.mounted) return null;
      showCustomSnackBar(
        context: registrationState.context,
        message: responseData?['message'] ?? "Something went wrong",
        color: Colors.red,
      );
    }
  } catch (e) {
    Utils.showNetworkErrorToast(registrationState.context, e.toString());
  } finally {
    registrationState.setIsLoading(false);
  }

  return null;
});

final verifyOtpProvider =
FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);
  final String previous = params['previous'];
  params.remove("previous");

  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.OTP_VERIFICATION}';
  try {
    final responseData = await apiService.verifyOtp(url, params, "");

    return {"response": responseData, "previous": previous};
  } catch (e) {
    throw Exception(e.toString());
  } finally {
    registrationState.setIsOTPVerify(false);
  }
});