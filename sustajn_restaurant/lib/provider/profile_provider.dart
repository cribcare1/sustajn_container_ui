import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';

import '../notifier/update_profile_notifier.dart';
import '../service/profile_service.dart';
import '../utils/utility.dart';

final profileProvider = ChangeNotifierProvider((ref) => ProfileState());

final getProfileProvider = FutureProvider.family<dynamic, String>(
      (ref, params) async {
    final profileState = ref.watch(profileProvider);
    try {
      var serviceProvider = ref.read(getProfileApiProvider);
      Utils.printLog("params===$params");
      GetProfileData responseData = await serviceProvider.getProfileService(params);
      if (responseData.status != null && responseData.status!.isNotEmpty) {
        profileState.setIsLoading(false);
        profileState.setProfileData(responseData);
      }
      else {
        profileState.setIsLoading(false);
        Utils.showToast(responseData.message!);
      }
      return responseData;
    } catch (e) {
      Utils.printLog("Get Profile provider error called: $e");
      profileState.setIsLoading(false);
      Utils.showNetworkErrorToast(profileState.context, e.toString());
    }
  },
);