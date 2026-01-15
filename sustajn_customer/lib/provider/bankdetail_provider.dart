import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sustajn_customer/auth/screens/bank_details_screen.dart';
import 'package:sustajn_customer/auth/screens/reset_password_screen.dart'
    show ResetPasswordScreen;
import 'package:sustajn_customer/auth/screens/subscription_screen.dart';
import 'package:sustajn_customer/notifier/signup_notifier.dart';
import 'package:sustajn_customer/utils/nav_utils.dart' show NavUtil;

import '../auth/dashboard_screen/dashboard_screen.dart';
import '../auth/dashboard_screen/home_screen.dart';
import '../auth/payment_type/payment_screen.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/map_screen.dart';
import '../auth/screens/save_home_address.dart';
import '../auth/screens/verify_email_screen.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../lottie_animations/account_create_animation.dart';
import '../models/login_model.dart';
import '../notifier/login_notifier.dart';
import '../service/bankdetail_service.dart';
import '../service/login_service.dart';
import '../utils/shared_preference_utils.dart';
import '../utils/utils.dart';

final bankDetailProvider = ChangeNotifierProvider((ref) => SignupNotifier());

final createBankProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(bankApiService);
  final bankState = ref.watch(bankDetailProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.CREATE_BANK}';
  try {
    var responseData = await apiService.createBankService(url, params, "");

    final status = responseData['status'];
    final message = responseData['message'];

    if (status != null &&
        status.isNotEmpty &&
        status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
      bankState.setIsLoading(false);
      NavUtil.navigateWithReplacement(SubscriptionScreen());
      showCustomSnackBar(
        context: bankState.context,
        message: message,
        color: Colors.green,
      );

    } else {
      if (!bankState.context.mounted) return;
      showCustomSnackBar(
        context: bankState.context,
        message: message!,
        color: Colors.black,
      );
      bankState.setIsLoading(false);
    }
  } catch (e) {
    bankState.setIsLoading(false);
    Utils.showNetworkErrorToast(bankState.context, e.toString());
  } finally {
    bankState.setIsLoading(false);
  }
  return null;
});

final updateBankProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(bankApiService);
  final bankState = ref.watch(bankDetailProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.UPDATE_BANK}';
  try {
    var responseData = await apiService.createBankService(url, params, "");

    final status = responseData['status'];
    final message = responseData['message'];

    if (status != null &&
        status.isNotEmpty &&
        status.trim().toString().toLowerCase() == NetworkUrls.SUCCESS) {
      bankState.setIsLoading(false);
      bankState.startTimer();
      showCustomSnackBar(
        context: bankState.context,
        message: message,
        color: Colors.green,
      );

    } else {
      if (!bankState.context.mounted) return;
      showCustomSnackBar(
        context: bankState.context,
        message: message!,
        color: Colors.black,
      );
      bankState.setIsLoading(false);
    }
  } catch (e) {
    bankState.setIsLoading(false);
    Utils.showNetworkErrorToast(bankState.context, e.toString());
  } finally {
    bankState.setIsLoading(false);
  }
  return null;
});



