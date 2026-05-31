import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_customer/auth/screens/reset_password_screen.dart'
    show ResetPasswordScreen;
import 'package:sustajn_customer/models/signup_model.dart';
import 'package:sustajn_customer/notifier/signup_notifier.dart';
import 'package:sustajn_customer/profile_screen/profile_screen.dart';
import 'package:sustajn_customer/utils/nav_utils.dart' show NavUtil;

import '../auth/dashboard_screen/home_screen.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/save_home_address.dart';
import '../auth/screens/verify_email_screen.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../lottie_animations/account_create_animation.dart';
import '../models/login_model.dart';
import '../service/bankdetail_service.dart';
import '../service/login_service.dart';
import '../utils/shared_preference_utils.dart';
import '../utils/utils.dart';

final signUpNotifier = ChangeNotifierProvider((ref) => SignupNotifier());

final loginDetailProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
      final apiService = ref.watch(loginApiService);
      final registrationState = ref.watch(signUpNotifier);

      var url = '${NetworkUrls.BASE_URL}${NetworkUrls.LOGIN_API}';
      var responseData = LoginModel();
      try {
        responseData = await apiService.loginUser(url, params, "");
        if (responseData.data!.userName != null) {
          registrationState.setIsLoading(false);
          registrationState.setLoginData(responseData);
          if (registrationState.context.mounted) {
            showCustomSnackBar(
              context: registrationState.context,
              message: Strings.LOGGED_SUCCESS,
              color: Colors.green,
            );
          }

          String json = jsonEncode(responseData.toJson());
          SharedPreferenceUtils.saveDataInSF(
            Strings.JWT_TOKEN,
            responseData.data!.jwtToken!,
          );
          SharedPreferenceUtils.saveDataInSF(Strings.IS_LOGGED_IN, true);
          SharedPreferenceUtils.saveDataInSF(Strings.PROFILE_DATA, json);
          SharedPreferenceUtils.saveDataInSF(
            Strings.USER_ID,
            responseData.data!.userId,
          );
          if (registrationState.context.mounted) {
            Navigator.pushReplacement(
              registrationState.context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
        } else {
          if (registrationState.context.mounted) {
            showCustomSnackBar(
              context: registrationState.context,
              message: "Login failed or response is not success",
              color: Colors.red,
            );
          }

          registrationState.setIsLoading(false);
          Utils.printLog('Login failed or response is not success');
        }
      } catch (e) {
        registrationState.setIsLoading(false);
        if (registrationState.context.mounted) {
          Utils.showNetworkErrorToast(registrationState.context, e.toString());
        }
      } finally {
        registrationState.setIsLoading(false);
      }
      return responseData;
    });



final registerProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiService);
  final registrationState = ref.watch(signUpNotifier);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.REGISTER_USER}';
  var responseData = SignUpModel();

  try {
    responseData = await apiService.registerUser(url, params, "");

    if (responseData.data != null &&
        responseData.data!.userName != null) {

      registrationState.setIsLoading(false);
      registrationState.setSignUPData(responseData);

      String json = jsonEncode(responseData.toJson());

      SharedPreferenceUtils.saveDataInSF(
        Strings.JWT_TOKEN,
        responseData.data!.jwtToken!,
      );
      SharedPreferenceUtils.saveDataInSF(
        Strings.IS_LOGGED_IN,
        true,
      );
      SharedPreferenceUtils.saveDataInSF(
        Strings.PROFILE_DATA,
        json,
      );
      SharedPreferenceUtils.saveDataInSF(
        Strings.USER_ID,
        responseData.data!.userId,
      );

      if (registrationState.context.mounted) {
        Navigator.pushReplacement(
          registrationState.context,
          MaterialPageRoute(
            builder: (_) => AccountSuccessScreen(),
          ),
        );
      }

    } else {
      if (registrationState.context.mounted) {
        showCustomSnackBar(
          context: registrationState.context,
          message: "Signup failed or response is not success",
          color: Colors.red,
        );
      }

      registrationState.setIsLoading(false);
      Utils.printLog('Signup failed or response is not success');
    }

  } catch (e) {
    registrationState.setIsLoading(false);
    if (registrationState.context.mounted) {
      Utils.showNetworkErrorToast(
        registrationState.context,
        e.toString(),
      );
    }
  } finally {
    registrationState.setIsLoading(false);
  }

  return responseData;
});


final forgotPasswordProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
      final apiService = ref.watch(loginApiService);
      final registrationState = ref.watch(signUpNotifier);

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
            message: responseData.message!,
            color: Colors.green,
          );
          Utils.navigateToPushScreen(
            registrationState.context,
            VerifyEmailScreen(previousScreen: 'forgotPassword'),
          );
        } else {
          if (!registrationState.context.mounted) return;
          showCustomSnackBar(
            context: registrationState.context,
            message: responseData.message!,
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

final getOtpToVerifyProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
      final apiService = ref.watch(loginApiService);
      final registrationState = ref.watch(signUpNotifier);

      var url = '${NetworkUrls.BASE_URL}${NetworkUrls.GET_OTP}';
      try {
        var responseData = await apiService.verifyOtp(url, params, "");

        final status = responseData['status'];
        final message = responseData['message'];

        if (status != null &&
            status.isNotEmpty &&
            status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
          registrationState.setIsLoading(false);
          registrationState.setSeconds(120);
          registrationState.startTimer();
          showCustomSnackBar(
            context: registrationState.context,
            message: message,
            color: Colors.green,
          );
          if (!registrationState.isResend) {
            Utils.navigateToPushScreen(
              registrationState.context,
              VerifyEmailScreen(previousScreen: ''),
            );
          } else {
            registrationState.setResend(false);
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
          registrationState.setIsLoading(false);
        }
      } catch (e) {
        registrationState.setSeconds(120);
        registrationState.startTimer();
        registrationState.setIsLoading(false);
        Utils.showNetworkErrorToast(registrationState.context, e.toString());
      } finally {
        registrationState.setIsLoading(false);
      }
      return null;
    });

final verifyOtpProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.watch(loginApiService);
  final registrationState = ref.watch(signUpNotifier);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.VERIFY_OTP}';
  try {
    var responseData = await apiService.verifyOtp(url, params, "");

    final status = responseData['status'];
    final message = responseData['message'];

    if (status != null &&
        status.isNotEmpty &&
        status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
      registrationState.setIsLoading(false);
      showCustomSnackBar(
        context: registrationState.context,
        message: message ?? "OTP verified successfully",
        color: Colors.green,
      );
      if (registrationState.isForgotPassword) {
        Utils.navigateToPushScreen(
          registrationState.context,
          ResetPasswordScreen(),
        );
      } else {
        NavUtil.navigateToPushScreen(registrationState.context,
          HomeAddress(flow: AddressFlow.signup,),
        );
      }
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

final resetPasswordProvider =
    FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
      final apiService = ref.watch(loginApiService);
      final registrationState = ref.watch(signUpNotifier);

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
            message: message ?? "Password reset successfully",
            color: Colors.green,
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

final getSubscriptionProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final apiService = ref.watch(loginApiService);
  final registrationState = ref.watch(signUpNotifier);

  try {
    var responseData = await apiService.getSubscriptionPlan(params);
    Utils.printLog(params);

    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.trim().toString().toLowerCase() ==
            NetworkUrls.SUCCESS) {
      registrationState.setIsLoading(false);
      registrationState.setSubscriptionModel(responseData);
    } else {
      if (!registrationState.context.mounted) return;
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

final createBankProvider =
FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.read(bankApiService);
  final signupState = ref.read(signUpNotifier);

  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.CREATE_BANK}';

  try {
    final responseData = await apiService.createBankService(url, params, "");

    final message = responseData['message'];

    signupState.setIsLoading(false);

    if (signupState.context.mounted) {
      showCustomSnackBar(
        context: signupState.context!,
        message: "Bank details created successfully",
        color: Colors.green,
      );
      Navigator.pop(signupState.context!);
    }
  } catch (e) {
    signupState.setIsLoading(false);

    if (signupState.context.mounted) {
      Utils.showNetworkErrorToast(
        signupState.context!,
        e.toString(),
      );
    }
  }
});

final updateBankProvider =
FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.read(bankApiService);
  final signupState = ref.read(signUpNotifier);

  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.UPDATE_BANK}';

  try {
    final responseData = await apiService.createBankService(url, params, "");

    final message = responseData['message'];

    signupState.setIsLoading(false);

    if (signupState.context.mounted) {
      showCustomSnackBar(
        context: signupState.context!,
        message: "Bank details updated successfully",
        color: Colors.green,
      );

      Navigator.pop(signupState.context!);
    }
  } catch (e) {
    signupState.setIsLoading(false);

    if (signupState.context.mounted) {
      Utils.showNetworkErrorToast(
        signupState.context!,
        e.toString(),
      );
    }
  }
});

