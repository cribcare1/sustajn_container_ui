import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_restaurant/auth/screens/login_screen.dart';
import 'package:sustajn_restaurant/auth/screens/verify_email_screen.dart';
import 'package:sustajn_restaurant/firebase_services.dart';
import 'package:sustajn_restaurant/utils/nav_utils.dart';

import '../auth/model/plan_model.dart';
import '../auth/screens/business_information_screen.dart';
import '../auth/screens/dashboard/dashboard_screen.dart';
import '../auth/screens/reset_password.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../lottie_animation/account_create_animation.dart';
import '../models/login_model.dart';
import '../models/register.dart';
import '../notifier/login_notifier.dart';
import '../service/login_service.dart';
import '../utils/sharedpreference_utils.dart';
import '../utils/utility.dart';

final authNotifierProvider = ChangeNotifierProvider.autoDispose<AuthState>((ref) => AuthState());

final loginDetailProvider =
FutureProvider.family<LoginModel, Map<String, dynamic>>(
        (ref, params) async {
      final apiService = ref.watch(loginApiProvider);
      final registrationState = ref.read(authNotifierProvider);

      final url = '${NetworkUrls.BASE_URL}${NetworkUrls.LOGIN_API}';

      try {
        final responseData = await apiService.loginUser(url, params, "");
        if (responseData.status == "success" &&
            responseData.data != null &&
            responseData.data!.userId != null &&
            responseData.data!.jwtToken != null) {
          await Future.delayed(const Duration(milliseconds: 500));
          final userId = responseData.data!.userId!;
          final planId = responseData.data!.planId!;
          final jwtToken = responseData.data!.jwtToken!;
          Utils.userId = responseData.data!.userId!;
          Utils.planId = responseData.data!.planId!;
          registrationState.setLoginData(responseData);
          registrationState.setUserId(userId);

          await SharedPreferenceUtils.saveDataInSF(
              Strings.JWT_TOKEN, jwtToken);

          await SharedPreferenceUtils.saveDataInSF(
              Strings.USER_ID, userId);
 await SharedPreferenceUtils.saveDataInSF(
              Strings.PLAN_ID, planId);
          Utils.fullName = responseData.data!.fullName!;
          await SharedPreferenceUtils.saveBoolDataInSF(
              Strings.IS_LOGGED_IN, true);
          Utils.userId = userId;
          await SharedPreferenceUtils.saveDataInSF(
            Strings.PROFILE_DATA,
            jsonEncode(responseData.toJson()),
          );
          try {
            await FirebaseServices().initialize();
          } catch (e) {
            print("Firebase init error: $e");
          }
          final context = registrationState.context;
          if (context.mounted) {
            showCustomSnackBar(
              context: context,
              message: Strings.LOGGED_SUCCESS,
              color: Colors.grey,
            );
            Utils.getUserId();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
          }

        } else {
          _showError(registrationState, "Login failed");
        }

        return responseData;

      } catch (e) {
        print("Login Exception: $e");
        _showError (registrationState, e.toString());
        rethrow;
      } finally {
        registrationState.setIsLoading(false);
      }
    });

void _showError(registrationState, String message) {
  final context = registrationState.context;

  if (context != null && context.mounted) {
    showCustomSnackBar(
      context: context,
      message: message,
      color: Colors.red,
    );
  }
}
///Register

final registerProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params,) async {
  final serviceProvider = ref.read(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);
  try {

    final Map<String, dynamic> data = Map<String, dynamic>.from(params);

    final response = await serviceProvider.registerUser(NetworkUrls.REGISTER_USER, data, "data",);

    if(response != null){
      LoginModel register = LoginModel.fromJson(response);
      if (register.status != null && register.status!.toLowerCase() == 'success') {
        Utils.printLog("Login Data  ${register.data!.toJson().toString()}");
        registrationState.setIsLoading(false);
        registrationState.setUserId(register.data!.userId!);
      await  SharedPreferenceUtils.saveDataInSF(
          Strings.JWT_TOKEN,
          register.data!.jwtToken!,
        );
       await SharedPreferenceUtils.saveDataInSF(
          Strings.USER_ID,
          register.data!.userId!,
        );

        await SharedPreferenceUtils.saveDataInSF(
            Strings.PLAN_ID, register.data!.planId!);
        await SharedPreferenceUtils.saveDataInSF(
            Strings.FULL_NAME, register.data!.fullName!);
        Utils.fullName = register.data!.fullName!;
       await SharedPreferenceUtils.saveBoolDataInSF(Strings.IS_LOGGED_IN, true);
        Utils.userId = register.data!.userId!;
        Utils.planId = register.data!.planId!;
        Utils.authToken();
        try {
          await FirebaseServices().initialize();
        } catch (e) {
          print("Firebase init error: $e");
        }
        NavUtil.navigateToWithReplacement(registrationState.context, AccountSuccessScreen(
          message: 'Your subscription is now active!',
        ));

      } else {
        showCustomSnackBar(
          context: registrationState.context,
          message: register.message!,
          color: Colors.black,
        );
        registrationState.setIsLoading(false);
      }
    }
  } catch (e, stackTrace) {
    // Optional: log error
    debugPrint('Register API Error: $e');
    debugPrintStack(stackTrace: stackTrace);
    Utils.showNetworkErrorToast(registrationState.context, e.toString());
    // Re-throw so Riverpod can catch and expose error
    throw Exception(e.toString());
  } finally {
    registrationState.setIsLoading(false);
  }
});

final forgotPasswordProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.FORGOT_PASSWORD}';
  try {
    var responseData = await apiService.forgetPassword(url, params, "");
    final status = responseData['status'];
    final message = responseData['message'];

    if (status != null &&
        status.isNotEmpty &&
        status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
      registrationState.setIsLoading(false);
      if (!registrationState.context.mounted) return;
      showCustomSnackBar(
        context: registrationState.context,
        message: message,
        color: Colors.grey,
      );
      NavUtil.navigateToPushScreen(
        registrationState.context,
        VerifyEmailScreen(previousScreen: 'forgotPassword'),
      );
    } else {
      if (!registrationState.context.mounted) return;
      showCustomSnackBar(
        context: registrationState.context,
        message: responseData.title!,
        color: Colors.red,
      );
      registrationState.setIsLoading(false);
    }
  } catch (e) {
    registrationState.setIsLoading(false);
    Utils.showNetworkErrorToast(registrationState.context, e.toString());
  } finally {
    registrationState.setIsLoading(false);
  }
  return null;
});

final validateEmail = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, args,) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);
  final String email = args['email'];
  final String previous = args['previous'];
  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.FORGOT_PASSWORD}';
  try {
    final responseData = await apiService.forgetPassword(url, {
      "email": email, "type":previous
    }, "");
    if (responseData != null && responseData.isNotEmpty) {
      if (!registrationState.context.mounted) return null;
      showCustomSnackBar(
        context: registrationState.context,
        message: "token sent to your email address",
        color: Colors.grey,
      );
      registrationState.setIsLoading(false);
      registrationState.setResendLoading(false);
      NavUtil.navigateToPushScreen(
        registrationState.context,
        VerifyEmailScreen(previousScreen: previous, email: email),
      );
    } else {
      registrationState.setIsLoading(false);
      registrationState.setResendLoading(false);
      if (!registrationState.context.mounted) return null;
      showCustomSnackBar(
        context: registrationState.context,
        message: responseData?['message'] ?? "Something went wrong",
        color: Colors.red,
      );
    }
  } catch (e) {
    registrationState.setIsLoading(false);
    registrationState.setResendLoading(false);
    Utils.showNetworkErrorToast(registrationState.context, e.toString());
  } finally {
    registrationState.setIsLoading(false);
    registrationState.setResendLoading(false);
  }

  return null;
});

final verifyOtpProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((
      ref,
      params,
    ) async {
      final apiService = ref.read(loginApiProvider);
      final registrationState = ref.watch(authNotifierProvider);
      final String previous = params['previous'];
      params.remove("previous");

      final url = '${NetworkUrls.BASE_URL}${NetworkUrls.VERIFY_OTP}';

      try {
        final responseData = await apiService.verifyOtp(url, params, "");
        final status = responseData['status'];
        final message = responseData['message'];

        if (status != null &&
            status.isNotEmpty &&
            status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
          registrationState.setVerifyLoading(false);
          registrationState.setSeconds(120);
          registrationState.startTimer();
          showCustomSnackBar(
            context: registrationState.context,
            message:  "OTP verified successfully",
            color: Colors.grey,
          );
          if (registrationState.isForgotPassword) {
            NavUtil.navigateToPushScreen(
              registrationState.context,
              ResetPasswordScreen(),
            );
          } else {
            NavUtil.navigateToPushScreen(registrationState.context,
              BusinessInformationDetails(
                authState: registrationState,
              ),
            );
          }
        } else {
          registrationState.setSeconds(120);
          registrationState.startTimer();
          if (!registrationState.context.mounted) return;
          showCustomSnackBar(
            context: registrationState.context,
            message: message!,
            color: Colors.black,
          );
          registrationState.setVerifyLoading(false);
        }

      }  catch (e) {
        registrationState.setSeconds(120);
        registrationState.startTimer();
        registrationState.setVerifyLoading(false);
        Utils.showNetworkErrorToast(registrationState.context, e.toString());
      } finally {
        registrationState.setVerifyLoading(false);
      }
      return null;
    });

final resetPasswordProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
      final apiService = ref.watch(loginApiProvider);
      final registrationState = ref.watch(authNotifierProvider);

      var url = '${NetworkUrls.BASE_URL}${NetworkUrls.RESET_PASSWORD}';
      try {
        var responseData = await apiService.resetPassword(url, params, "");

        final status = responseData['status'];
        final message = responseData['message'];

        if (status != null &&
            status.isNotEmpty &&
            status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
          registrationState.setIsLoading(false);
          showCustomSnackBar(
            context: registrationState.context,
            message: "Password reset successfully",
            color: Colors.grey,
          );
          NavUtil.navigationToWithReplacement(
            registrationState.context,
            LoginScreen(),
          );
        } else {
          if (!registrationState.context.mounted) return;
          showCustomSnackBar(
            context: registrationState.context,
            message: message!,
            color: Colors.black,
          );
          registrationState.setIsLoading(false);
        }
      } catch (e) {
        registrationState.setIsLoading(false);
        Utils.showNetworkErrorToast(registrationState.context, e.toString());
      } finally {
        registrationState.setIsLoading(false);
      }
      return null;
    });

final subscriptionProvider =
    FutureProvider.family<List<PlanModel>, Map<String, dynamic>>((
      ref,
      body,
    ) async {
      final provider = ref.read(authNotifierProvider);
      final service = ref.read(loginApiProvider);
      try {
        List<PlanModel>? response = await service.planServices();

        if (response != null && response.length>0) {
          provider.setPlan(response!);
        }
        return response!;
      } catch (e) {
        if (provider.context.mounted) {
          Utils.showNetworkErrorToast(provider.context, e.toString());
        }
        provider.setPlanError(e.toString());
        return [];
      } finally {
        provider.setIsPlanLoading(false);
      }
    });
