import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../models/damage_partner_data.dart';
import '../models/damage_user_data.dart';
import 'damage_notifier.dart';
import 'damage_service.dart';

final DamageUserProvider = ChangeNotifierProvider((ref) => DamageNotifier());

final getDamageUserDataProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final damageNotifier = ref.watch(DamageUserProvider);
  try {
    var serviceProvider = ref.read(damageServices);
    Utils.printLog("params===$params");
    DamageUserData responseData = await serviceProvider.getDamageUserService(
      params,
    );
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      damageNotifier.setIsLoading(false);
      damageNotifier.setDamageUserData(responseData);
    } else {
      damageNotifier.setIsLoading(false);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    damageNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(damageNotifier.context, e.toString());
  }
});

final getDamagePartnerDataProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final damageNotifier = ref.watch(DamageUserProvider);
  try {
    var serviceProvider = ref.read(damageServices);
    Utils.printLog("params===$params");
    DamagePartnerData responseData = await serviceProvider
        .getDamagePartnerService(params);
    Utils.printLog("On Success===${responseData.status}");
    if (responseData.status != null &&
        responseData.status!.isNotEmpty &&
        responseData.status!.toLowerCase() == Strings.SUCCESS) {
      Utils.printLog("On Success===${responseData.status}");
      damageNotifier.setIsLoading(false);
      damageNotifier.setDamagePartnerData(responseData);
    } else {
      damageNotifier.setIsLoading(false);
    }
    return null;
  } catch (e) {
    Utils.printLog("Get Users provider error called: $e");
    damageNotifier.setIsLoading(false);
    Utils.showNetworkErrorToast(damageNotifier.context, e.toString());
  }
});
