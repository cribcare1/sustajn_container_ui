import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_customer/notifier/product_notifier.dart';
import 'package:sustajn_customer/notifier/profile_notifier.dart';
import 'package:sustajn_customer/service/product_serivice.dart';

import '../constants/imports_util.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../models/profile_update_data.dart';
import '../service/profile_service.dart';
import '../utils/utils.dart';

final profileProvider = ChangeNotifierProvider((ref) => ProfileNotifier());

final getProfileProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final profileState = ref.watch(profileProvider);
  try {
    var serviceProvider = ref.read(getProfileApiService);
    Utils.printLog("params===$params");
    var responseData = await serviceProvider.getProfileService(params);
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      profileState.setIsLoading(false);
      profileState.setProfileList(responseData);
    } else {
      profileState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
  } catch (e) {
    Utils.printLog("Get product provider error called: $e");
    profileState.setIsLoading(false);
    Utils.showNetworkErrorToast(profileState.context, e.toString());
  }
});


final profileUpdateProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final profileState = ref.watch(profileProvider);
  try {
    var serviceProvider = ref.read(getProfileApiService);
    var partUrl = params[Strings.PART_URL];
    var data = params[Strings.DATA];
    var requestKey = params[Strings.REQUEST_KEY];
    File? image = params.containsKey(Strings.IMAGE)
        ? params[Strings.IMAGE] as File?
        : null;

    Utils.printLog("partUrl===$partUrl");
    var responseData = await serviceProvider.profileUpdateService(
      partUrl,
      data,
      requestKey,
      image,
    );
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      profileState.setIsLoading(false);
      if(profileState.context.mounted) {
        showCustomSnackBar(context: profileState.context,
            message: responseData.message!, color:Colors.green);
      }
    } else {
      Utils.showToast(
        responseData.message ?? "Update failed",
      );
    }
  } catch (e) {
    Utils.printLog(" provider error called: $e");
    profileState.setIsLoading(false);
    Utils.showToast(
      "Something went wrong. Please try again",
    );
    Utils.showNetworkErrorToast(profileState.context, e.toString());
  }
});
