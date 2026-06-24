import 'package:container_tracking/order_request_screen/provider_service/order_request_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../Screen/users/model/users_data.dart';
import '../../Screen/users/notifier/users_notifier.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';

final orderRequestProvider = ChangeNotifierProvider((ref) => UsersNotifier());

final getPendingOrderProvider = FutureProvider.family<dynamic, String>((
    ref,
    params,
    ) async {
  final userNotifier = ref.watch(orderRequestProvider);
  try {
    var serviceProvider = ref.read(orderRequestServices);
    Utils.printLog("params===$params");
    UsersData responseData = await serviceProvider.getPendingOrderService(params);
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