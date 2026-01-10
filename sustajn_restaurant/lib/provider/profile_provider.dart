import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_restaurant/models/get_profile_data.dart';

import '../constants/network_urls.dart';
import '../notifier/update_profile_notifier.dart';
import '../service/profile_service.dart';
import '../utils/utility.dart';

final profileProvider = ChangeNotifierProvider((ref) => ProfileState());

final getProfileProvider =
FutureProvider.family<GetProfileData, void>((ref, _) async {
  final authServices = ref.read(getProfileApiProvider);

  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.GET_PROFILE}';

  try {
    final response = await authServices.getProfileService(url, 'GET');
    return response as GetProfileData;
  } catch (e) {
    Utils.printLog('Get Profile Provider Error: $e');
    rethrow;
  }
});
