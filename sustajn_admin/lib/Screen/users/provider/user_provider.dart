import 'package:container_tracking/Screen/Partner/provider/notifier/product_notifier.dart';
import 'package:container_tracking/Screen/users/notifier/users_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../constants/string_utils.dart';
import '../../../../utils/utility.dart';

import 'dart:convert';

import '../model/user_sold_container_data.dart';
import '../model/users_data.dart';
import '../service/users_service.dart';

final userProvider = ChangeNotifierProvider((ref) => UsersNotifier());

final getUsersDataProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final userNotifier = ref.watch(userProvider);
  try {
    var serviceProvider = ref.read(getUsersApiService);
    Utils.printLog("params===$params");
    UsersData responseData = await serviceProvider.getUsersService(
      params,
    );
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null && responseData.status!.isNotEmpty && responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      userNotifier.setIsLoading(false);
      userNotifier.setUsersData(responseData);
    } else {
      userNotifier.setIsLoading(false);
      //Utils.showToast(responseData.message!);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    userNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(userNotifier.context, e.toString());
  }
});

final userActiveProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final productState = ref.watch(userProvider);
  try {
    var serviceProvider = ref.read(getUsersApiService);
    Utils.printLog("params===$params");
    var responseData = await serviceProvider.productService(params);
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      productState.setIsLoading(false);
      productState.setProductData(responseData);
    } else {
      productState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
  } catch (e) {
    Utils.printLog("Get product provider error called: $e");
    productState.setIsLoading(false);
    Utils.showNetworkErrorToast(productState.context, e.toString());
  }
});
final borrowedProvider = FutureProvider.family<dynamic, String>(
      (ref, params) async {
    final borrowedState = ref.watch(userProvider);
    try {
      var serviceProvider = ref.read(getUsersApiService);
      Utils.printLog("params===$params");
      var responseData = await serviceProvider.borrowedService(params);
      if (responseData.status != null && responseData.status!.isNotEmpty ) {
        borrowedState.setIsLoading(false);
        borrowedState.setBorrowedData(responseData);

      }else{
        borrowedState.setIsLoading(false);
        Utils.showToast(responseData.message!);
      }
    } catch (e) {
      Utils.printLog("Get borrowed provider error called: $e");
      borrowedState.setIsLoading(false);
      Utils.showNetworkErrorToast(borrowedState.context, e.toString());
    }
  },
);
final getSoldContainerProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final containerState = ref.watch(userProvider);
  try {
    var serviceProvider = ref.read(getUsersApiService);
    Utils.printLog("params===$params");
    SoldContainerData responseData = await serviceProvider
        .getSoldContainerService(params);
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      containerState.setIsLoading(false);
      containerState.setSoldContainerData(responseData);
    } else {
      containerState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return responseData;
  } catch (e) {
    Utils.printLog("Get sold provider error called: $e");
    containerState.setIsLoading(false);
    Utils.showNetworkErrorToast(containerState.context, e.toString());
  }
});