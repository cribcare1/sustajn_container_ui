import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/constants/network_urls.dart';
import 'package:sustajn_restaurant/lease_receive/lease_and_receive_services.dart';
import 'package:sustajn_restaurant/lease_receive/lease_receive_notifier.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../constants/imports_util.dart';
import 'model/container_list_model.dart';
import 'model/container_return_list_model.dart';

final leaseContainer = FutureProvider.family<dynamic, Map<String, dynamic>>((
  ref,
  params,
) async {
  final apiService = ref.watch(leaseAPIServices);
  final leaseNotifier = ref.watch(leaseReceiveNotifier);
  try {
    final response = await apiService.leaseContainer((params));
    if(response != null && response['status'] == NetworkUrls.SUCCESS){
      print("✅ SUCCESS BLOCK EXECUTED");
      showCustomSnackBar(
        context: leaseNotifier.context!,
        message:  response['message'],
        color: Colors.green,
      );
      Navigator.pop(leaseNotifier.context!);
      Navigator.pop(leaseNotifier.context!);
      Navigator.pop(leaseNotifier.context!);
    }else{
      leaseNotifier.setIsSaving(false);
      showCustomSnackBar(
        context: leaseNotifier.context!,
        message: response['message']??"Something went wrong",
        color: Colors.red,
      );
    }
    return response;
  } catch (e) {
    leaseNotifier.setIsSaving(false);
    showCustomSnackBar(
      context: leaseNotifier.context!,
      message: e.toString(),
      color: Colors.red,
    );
  } finally {
    leaseNotifier.setIsSaving(false);
  }
});

final receiveContainer = FutureProvider.family<dynamic, Map<String, dynamic>>((
    ref,
    params,
    ) async {
  final apiService = ref.watch(leaseAPIServices);
  final leaseNotifier = ref.watch(leaseReceiveNotifier);
  try {
    final response = await apiService.receiveContainer(params);
    if(response != null && response['status'] == NetworkUrls.SUCCESS){
      print("✅ SUCCESS BLOCK EXECUTED");
      showCustomSnackBar(
        context: leaseNotifier.context!,
        message:  response['message'],
        color: Colors.green,
      );
      Navigator.pop(leaseNotifier.context!);
      Navigator.pop(leaseNotifier.context!);
      Navigator.pop(leaseNotifier.context!);
    }else{
      showCustomSnackBar(
        context: leaseNotifier.context!,
        message: response['message']??"Something went wrong",
        color: Colors.red,
      );
    }
    return response;
  } catch (e) {
    showCustomSnackBar(
      context: leaseNotifier.context!,
      message: e.toString(),
      color: Colors.red,
    );
  } finally {
    leaseNotifier.setIsSaving(false);
  }
});

final containerListProvider =
FutureProvider.family<ContainerListModel, String>((ref, restaurantId) async {
  final apiService = ref.watch(leaseAPIServices);
  final leaseNotifier = ref.watch(leaseReceiveNotifier);

  try {
    final response = await apiService.fetchContainerList(restaurantId);
    if  (response.status == NetworkUrls.SUCCESS && response.containersDetails.isNotEmpty) {
      leaseNotifier.setContainer(response.containersDetails);
    }else{
      showCustomSnackBar(
        context: leaseNotifier.context!,
        message: response.message,
        color: Colors.red,
      );
    }
    return response;
  } catch (e) {
    showCustomSnackBar(
      context: leaseNotifier.context!,
      message: e.toString(),
      color: Colors.red,
    );
    rethrow;
  } finally {
    leaseNotifier.setLoading(false);
  }
});

final returnContainerListProvider =
FutureProvider.family<ContainerReturnListModel, String>((ref, userId) async {
  final apiService = ref.watch(leaseAPIServices);
  final leaseNotifier = ref.watch(leaseReceiveNotifier);

  try {
    final response = await apiService.fetchReturnContainerList(userId);
    if  (response.status == NetworkUrls.SUCCESS && response.productList.isNotEmpty) {
      leaseNotifier.setReturnContainer(response.productList);
      showCustomSnackBar(
        context: leaseNotifier.context!,
        message: "Please Scan container",
        color: Colors.green
      );
    }else{
      showCustomSnackBar(
        context: leaseNotifier.context!,
        message: response.message,
        color: Colors.red,
      );
    }
    return response;
  } catch (e) {
    showCustomSnackBar(
      context: leaseNotifier.context!,
      message: e.toString(),
      color: Colors.red,
    );
    rethrow;
  } finally {
    leaseNotifier.setLoading(false);
  }
});
