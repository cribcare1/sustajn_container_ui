import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../auth/dashboard_screen/dashboard_screen.dart';
import '../auth/dashboard_screen/home_screen.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/verify_email_screen.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../models/login_model.dart';
import '../notifier/login_notifier.dart';
import '../service/login_service.dart';
import '../utils/shared_preference_utils.dart';
import '../utils/utils.dart';

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


