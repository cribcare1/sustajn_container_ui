import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../auth/auth_services/auth_services.dart';
import '../auth/model/login_model.dart';
import '../auth/screens/dashboard_screen.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../firebase_services.dart';
import '../notifier/login_notifier.dart';
import '../service/login_service.dart';
import '../utils/SharedPreferenceUtils.dart';
import '../utils/nav_utils.dart';
import '../utils/utility.dart';

final authNotifierProvider = ChangeNotifierProvider((ref) => AuthState());

final loginDetailProvider =
FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.watch(loginApiProvider);
  final registrationState = ref.watch(authNotifierProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.LOGIN_API}';
  var responseData = LoginModel();
  try {
    responseData = await apiService.loginUser(url, params, "");
    if (responseData.data != null) {
      print("++++++++++++++++++++++++++++");
      registrationState.setIsLoading(false);
      registrationState.setLoginData(responseData);
      if (registrationState.context.mounted) {
        showCustomSnackBar(
          context: registrationState.context,
          message: Strings.LOGGED_SUCCESS,
          color: Colors.grey,
        );
      }
      registrationState.setUserId(responseData.data!.userId!);
      SharedPreferenceUtils.saveDataInSF(
        Strings.JWT_TOKEN,
        responseData.data!.jwtToken!,
      );
      SharedPreferenceUtils.saveDataInSF(
        Strings.USER_ID,
        responseData.data!.userId!,
      );
      Utils.userId = responseData.data!.userId!;
      SharedPreferenceUtils.saveBoolDataInSF(Strings.IS_LOGGED_IN, true);
      print("========================================");
      await FirebaseServices().initialize();
      if (registrationState.context.mounted) {
        NavUtil.navigateWithReplacement(DashboardScreen());
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

