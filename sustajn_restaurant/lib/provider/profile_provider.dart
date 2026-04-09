import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_restaurant/auth/screens/dashboard/dashboard_screen.dart';
import 'package:sustajn_restaurant/models/chart_model.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants/imports_util.dart';
import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../lease_receive/model/container_return_list_model.dart';
import '../models/update_address_data.dart';
import '../notifier/profile_notifier.dart';
import '../service/profile_service.dart';
import '../utils/sharedpreference_utils.dart';
import '../utils/utility.dart';

final profileProvider = ChangeNotifierProvider((ref) => ProfileState());

final getProfileProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final profileState = ref.watch(profileProvider);
  try {
    var serviceProvider = ref.read(getProfileApiProvider);
    Utils.printLog("params===$params");
    GetProfileData responseData = await serviceProvider.getProfileService(
      params,
    );
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == NetworkUrls.SUCCESS) {
      profileState.setIsLoading(false);
      String json = jsonEncode(responseData.toJson());
      SharedPreferenceUtils.saveDataInSF(Strings.PROFILE_DATA, json);
      profileState.setProfileData(responseData);
      profileState.setProfile();
    } else {
      profileState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Profile provider error called: $e");
    profileState.setIsLoading(false);
    Utils.showNetworkErrorToast(profileState.context, e.toString());
  }
});

final profileUpdateProvider =
FutureProvider.family<GetProfileData, Map<String, dynamic>>(
      (ref, params) async {
    final apiService = ref.read(getProfileApiProvider);
    final profileState = ref.watch(profileProvider);
    final partUrl = params[NetworkUrls.UPDATE_PROFILE];
    final data = params[Strings.USER_DATA];
    final url = '${NetworkUrls.BASE_URL}$partUrl';

    Utils.printLog("Provider url : $url");
    final responseData =
    await apiService.profileUpdateService(url, data, "");

    print("Provider Response: $responseData");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == NetworkUrls.SUCCESS) {
      profileState.setIsSaving(false);
      String json = jsonEncode(responseData.toJson());
      SharedPreferenceUtils.saveDataInSF(Strings.PROFILE_DATA, json);
      final userId = Utils.userId;
      final url = '${NetworkUrls.GET_PROFILE}$userId';
      ref.read(getProfileProvider(url));
      Navigator.pop(profileState.context);
    }else {
      profileState.setIsSaving(false);
      throw Exception(responseData.message ?? 'Update failed');
    }
    return responseData;
  },
);


final profileImgProvider =
FutureProvider.family<GetProfileData, Map<String, dynamic>>((ref, params) async {
    final serviceProvider = ref.read(getProfileApiProvider);
    final image = params[Strings.IMAGE];
    params.remove(Strings.IMAGE);
    params.remove('part_url');
    final Map<String, dynamic> data = Map<String, dynamic>.from(params['data']);

    final response = await serviceProvider.updateImageService(
      NetworkUrls.UPDATE_PROFILE,
      data,
      "profileImage",
      image,
    );
    if (response.status != null &&
        response.status!.isNotEmpty &&
        response.status!.toLowerCase() == NetworkUrls.SUCCESS) {
      return response;
    } else {
      throw Exception(
        response.message ?? "Profile image update failed",
      );
    }
  },
);


final addressUpdateProvider =
FutureProvider.family<UpdateProfAddressData, Map<String, dynamic>>(
      (ref, params) async {
    final apiService = ref.read(getProfileApiProvider);

    final partUrl = params[NetworkUrls.UPDATE_ADDRESS];
    final url = '${NetworkUrls.BASE_URL}$partUrl';
    final requestData =
    params[Strings.USER_DATA] as Map<String, dynamic>;
    Utils.printLog("Provider url : $url");
    final responseData =
    await apiService.addressService(url, requestData);

    print("Provider Response: $responseData");
    if (responseData.status == null || responseData.status!.isEmpty) {
      throw Exception(responseData.title ?? 'Update failed');
    }
    return responseData;
  },
);

final referPartnerProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final apiService = ref.read(getProfileApiProvider);
  final profileState = ref.watch(profileProvider);
  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.REFER_A_PARTNER}';

  Utils.printLog("Refer Partner Provider url : $url");
  final responseData = await apiService.referPartnerService(url, params, "");
  print("Provider Response: $responseData");
  Utils.showToast(
      responseData['message']);
  Navigator.pop(profileState.context);
  return responseData;
});


final businessInfoProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final apiService = ref.read(getProfileApiProvider);

  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.BUSINESS_INFO}';

  Utils.printLog("Business Info Provider url : $url");
  final responseData = await apiService.businessInfoService(url, params, "");

  print("Provider Response: $responseData");
  return responseData;
});


final feedbackProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final apiService = ref.read(getProfileApiProvider);

  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.FEEDBACK}';

  Utils.printLog("{Feedback Provider url : $url");
  final responseData = await apiService.feedbackService(url, params, "");
  print("Provider Response: $responseData");
  return responseData;
});


final updateSubscriptionPlanProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final apiService = ref.read(getProfileApiProvider);
  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.UPGRADE_SUBSCRIPTION_PLAN}';

  Utils.printLog("Upgrade Subscription plan Provider url : $url");
  final responseData = await apiService.updateSubscriptionPlanService(url, params, "");

  print("Provider Response: $responseData");
  final userId = Utils.userId;
  final url1 = '${NetworkUrls.GET_PROFILE}$userId';
  ref.read(getProfileProvider(url1));
  return responseData;
});

final damageContainerList =
FutureProvider.family<CustomerBorrowedData, String>((ref, customerId) async {
  final apiService = ref.watch(getProfileApiProvider);
  final leaseNotifier = ref.watch(profileProvider);

  try {
    final response = await apiService.fetchCustomerBorrowedList(customerId);
    if  (response.status == NetworkUrls.SUCCESS && response.data!.isNotEmpty) {
      leaseNotifier.setReturnContainer(response.data!);

    }else{
      showCustomSnackBar(
        context: leaseNotifier.context,
        message: response.message!,
        color: Colors.red,
      );
    }
    return response;
  } catch (e) {
    showCustomSnackBar(
      context: leaseNotifier.context,
      message: e.toString(),
      color: Colors.red,
    );
    rethrow;
  } finally {
    leaseNotifier.setLoading(false);
  }
});
final damageContainer = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, body)async{
  final apiService = ref.watch(getProfileApiProvider);
  final leaseNotifier = ref.watch(profileProvider);
  final updatedBody = Map<String, dynamic>.from(body);
  File image = File(updatedBody['image']);
  updatedBody.remove('image');
  try{
    final response = await apiService.markDamageContainer(updatedBody, image);
    if(response != null){
      damageContainerList(body['restaurantId']);
      showCustomSnackBar(
        context: leaseNotifier.context,
        message: response['message'],
        color: Colors.green,
      );
      Navigator.pop(leaseNotifier.context);
    }
  }catch(e){
    leaseNotifier.setIsSaving(false);
    showCustomSnackBar(
      context: leaseNotifier.context,
      message: e.toString(),
      color: Colors.red,
    );
    rethrow;
  }finally{
    leaseNotifier.setIsSaving(false);
  }
});

final getChartData = FutureProvider.family<dynamic, String>((ref, param)async{
  final apiService = ref.watch(getProfileApiProvider);
  final leaseNotifier = ref.watch(profileProvider);
  try{
    ChartModel response = await apiService.fetchChartData(param);
    leaseNotifier.setChartData(response);
    return response;
  }catch(e){
    leaseNotifier.setDashboardLoading(false);
    showCustomSnackBar(
      context: leaseNotifier.context,
      message: e.toString(),
      color: Colors.red,
    );
    rethrow;
  }finally{
    leaseNotifier.setDashboardLoading(false);
  }
});