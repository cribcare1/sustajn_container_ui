import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';

import '../constants/network_urls.dart';
import '../constants/string_utils.dart';
import '../models/update_profile_data.dart';
import '../notifier/profile_notifier.dart';
import '../service/profile_service.dart';
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
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      profileState.setIsLoading(false);
      profileState.setProfileData(responseData);
    } else {
      profileState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
    return responseData;
  } catch (e) {
    Utils.printLog("Get Profile provider error called: $e");
    profileState.setIsLoading(false);
    Utils.showNetworkErrorToast(profileState.context, e.toString());
  }
});

final profileUpdateProvider =
FutureProvider.family<UpdateProfileData, Map<String, dynamic>>(
      (ref, params) async {
    final apiService = ref.read(getProfileApiProvider);

    final partUrl = params[NetworkUrls.UPDATE_PROFILE];
    final data = params[Strings.USER_DATA];
    final url = '${NetworkUrls.BASE_URL}$partUrl';

    Utils.printLog("Provider url : $url");
    final responseData =
    await apiService.profileUpdateService(url, data, "");

    print("Provider Response: $responseData");
    if (responseData.status == null || responseData.status!.isEmpty) {
      throw Exception(responseData.message ?? 'Update failed');
    }
    return responseData;
  },
);


final profileImgProvider =
FutureProvider.family<UpdateProfileData, Map<String, dynamic>>(
      (ref, params) async {
    final serviceProvider = ref.read(getProfileApiProvider);
    final image = params[Strings.IMAGE];
    params.remove(Strings.IMAGE);
    final Map<String, dynamic> data = Map<String, dynamic>.from(params);

    final response = await serviceProvider.updateImageService(
      NetworkUrls.UPDATE_PROFILE,
      data,
      "profileImage",
      image,
    );
    print(response);
    return response;
  },
);


