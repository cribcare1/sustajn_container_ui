import 'package:container_tracking/Screen/Partner/provider/notifier/product_notifier.dart';
import 'package:container_tracking/Screen/users/notifier/users_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../constants/string_utils.dart';
import '../../../../utils/utility.dart';

import 'dart:convert';

import '../model/users_data.dart';
import '../service/users_service.dart';

final userProvider = ChangeNotifierProvider((ref) => UsersNotifier());

final getUsersDataProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final userNotifier = ref.watch(userProvider);
  try {
    var serviceProvider = ref.read(getUsersApiProvider);
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
