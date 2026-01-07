import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sustajn_restaurant/auth/screens/login_screen.dart';
import 'package:sustajn_restaurant/auth/screens/verify_email_screen.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../auth/model/plan_model.dart';
import '../auth/screens/dashboard_screen.dart';
import '../auth/screens/reset_password.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../models/register.dart';
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
      SharedPreferenceUtils.saveBoolDataInSF(Strings.IS_LOGGED_IN, true);
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

final registerProvider =
FutureProvider.family<Register, Map<String, dynamic>>(
      (ref, params) async {
    final serviceProvider = ref.read(loginApiProvider);
    final image = params[Strings.IMAGE];
    params.remove(Strings.IMAGE);
    final Map<String, dynamic> data = Map<String, dynamic>.from(params);

    final response = await serviceProvider.registerUser(
      NetworkUrls.REGISTER_USER,
      data,
      "data",
      image,
    );
print(response);
    return response;
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
      NavUtil.navigateToPushScreen(registrationState.context, ResetPasswordScreen());
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
      NavUtil.navigateToPushScreen(registrationState.context, VerifyEmailScreen(previousScreen: previous, email: email));
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
FutureProvider.family<Map<String, dynamic>, Map<String, dynamic>>(
      (ref, params) async {
    final apiService = ref.read(loginApiProvider);

    final String previous = params['previous'];
    params.remove("previous");

    final url =
        '${NetworkUrls.BASE_URL}${NetworkUrls.VERIFY_OTP}';

    try {
      final responseData =
      await apiService.verifyOtp(url, params, "");

      print("VERIFY OTP RESPONSE =====> $responseData");

      return {
        "response": responseData,
        "previous": previous,
      };
    } catch (e) {
      throw Exception(e.toString());
    }
  },
);

final resetPasswordProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.RESET_PASSWORD}';
  try {
    var   responseData = await apiService.resetPassword(url, params, "");

    final status = responseData['status'];
    final message = responseData['message'];

    if (status != null && status.isNotEmpty  && status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
      registrationState.setIsLoading(false);
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

final subscriptionProvider =
FutureProvider.family<List<PlanModel>, Map<String, dynamic>>(
        (ref, body) async {
      final provider = ref.read(authNotifierProvider);
      final service = ref.read(loginApiProvider);
      try {
        final response = await service.planServices();
        provider.setPlan(response!);
        return response;
      } catch (e) {
        if (provider.context.mounted) {
          Utils.showNetworkErrorToast(
            provider.context,
            e.toString(),
          );
        }
        provider.setPlanError(e.toString());
        return [];
      } finally {
        provider.setIsPlanLoading(false);
      }
    });