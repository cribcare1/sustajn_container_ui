import 'dart:convert';
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
import '../models/update_image.dart';
import '../service/delete_address_service.dart';
import '../service/profile_service.dart';
import '../utils/shared_preference_utils.dart';
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
      String json = jsonEncode(responseData.toJson());
      SharedPreferenceUtils.removeValueFromSF(Strings.PROFILE_DATA);
      SharedPreferenceUtils.saveDataInSF(Strings.PROFILE_DATA, json);
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

final deleteAddressProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final apiService = ref.watch(getProfileApiService);
  final deleteState = ref.watch(profileProvider);

  try {
    var url = '${NetworkUrls.BASE_URL}${NetworkUrls.DELETE_ADDRESS}';
    var responseData = await apiService.deleteAddress(url, params);

    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.trim().toString().toLowerCase() ==
            NetworkUrls.SUCCESS) {
      deleteState.setIsLoading(false);
      if (!deleteState.context!.mounted) return;
      showCustomSnackBar(
        context: deleteState!.context,
        message: responseData.message!,
        color: Colors.green,
      );
    } else {
      if (!deleteState.context!.mounted) return;
      showCustomSnackBar(
        context: deleteState!.context,
        message: responseData.message!,
        color: Colors.black,
      );
      deleteState.setIsLoading(false);
    }
  } catch (e) {
    deleteState.setIsLoading(false);
    Utils.showNetworkErrorToast(deleteState.context, e.toString());
  } finally {
    deleteState.setIsLoading(false);
  }
  return null;
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
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData!.status!.toLowerCase()==NetworkUrls.SUCCESS) {
      profileState.setIsLoading(false);
      String json = jsonEncode(responseData.toJson());
      // SharedPreferenceUtils.removeValueFromSF(Strings.PROFILE_DATA);
      SharedPreferenceUtils.saveDataInSF(Strings.PROFILE_DATA, json);
      if(profileState.context.mounted) {
        showCustomSnackBar(context: profileState.context,
            message: responseData.message!, color:Colors.green);
      }
    }
    else {
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

final uploadImageProvider =
FutureProvider.family<UpdateImage, Map<String, dynamic>>((ref, params) async {

  final serviceProvider = ref.read(getProfileApiService);

  final String partUrl = params[Strings.PART_URL];
  final String requestKey = params[Strings.REQUEST_KEY];
  final File image = params[Strings.IMAGE];

  final responseData = await serviceProvider.uploadImage(
    partUrl,
    requestKey,
    image,
  );

  final isSuccess =
      responseData.message?.toLowerCase() == "success";

  if (!isSuccess) {
    Utils.showToast(
      responseData.status ?? "Image upload failed",
    );
  }

  return responseData;
});




