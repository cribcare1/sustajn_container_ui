import 'dart:io';

import 'package:container_tracking/container_list/container_service.dart';
import 'package:container_tracking/container_list/container_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../utils/strings_utility.dart';
import '../utils/utility.dart';
import 'model/container_list_model.dart';

final containerNotifierProvider = ChangeNotifierProvider((ref) => ContainerState());

final addContainerProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params)async{
  final apiService = ref.watch(containerApiProvider);
  final containerState = ref.watch(containerNotifierProvider);

  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.ADD_CONTAINER}';
  try{
var response = await apiService.addContainer(url, params, "data", (containerState.image!.path.contains("http:"))?null: containerState.image??File(""));
if(response != null && response['status'] =="success"){
  if(containerState.context.mounted) {
    showCustomSnackBar(context: containerState.context,
        message: response['message'], color:Colors.green);
    containerState.setImage(null);
    Navigator.of(containerState.context).pop(true);
  }
}else{
  if(containerState.context.mounted){
    showCustomSnackBar(context: containerState.context,
        message: response['message'], color:Colors.red);
  }
}
   
  }catch(e){
    if(containerState.context.mounted){
      showCustomSnackBar(context: containerState.context,
          message: e.toString(), color:Colors.red);
    }
  }finally{
      containerState.setIsLoading(false);
  }
});

final fetchContainerProvider = FutureProvider.family<dynamic, dynamic>((ref, params) async {
  final apiService = ref.watch(containerApiProvider);
  final containerState = ref.watch(containerNotifierProvider);


  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.CONTAINER_LIST}';

  try {

    var responseData = await apiService.fetchContainer(url);

    if (responseData != null) {
      containerState.setIsLoading(false);
      containerState.setContainerList(responseData.inventoryData);
    } else {
      containerState.setIsLoading(false);
    }
  } catch (e) {
    containerState.setContainerListError(e.toString());
    if (containerState.context.mounted) {
      showCustomSnackBar(
        context: containerState.context,
        message: e.toString(),
        color: Colors.red,
      );
    }
  } finally {
      containerState.setIsLoading(false);
  }
});

final deleteContainer = FutureProvider.family<dynamic, dynamic>((ref, params) async {
  final apiService = ref.watch(containerApiProvider);
  final containerState = ref.watch(containerNotifierProvider);


  var url = '${NetworkUrls.BASE_URL}${NetworkUrls.DELETE_CONTAINER}/$params';

  try {
    var response = await apiService.deleteContainer(url);

    if (containerState.context.mounted) {
    }

    return response;

  } catch (e) {
    if (containerState.context.mounted) {
      showCustomSnackBar(
        context: containerState.context,
        message: e.toString(),
        color: Colors.red,
      );
    }
  } finally {
      containerState.setIsLoading(false);
  }
});