import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_customer/notifier/search_res_notifier.dart';
import 'package:sustajn_customer/service/address_service.dart';

import '../constants/imports_util.dart';
import '../constants/network_urls.dart';
import '../models/resturant_address_model.dart';
import '../profile_screen/edit_dialogs/address_screen.dart';
import '../service/search_res_service.dart';
import '../utils/nav_utils.dart';
import '../utils/utils.dart';


final searchResProvider = ChangeNotifierProvider<SearchResState>((res) => SearchResState());

final searchRes =
FutureProvider.family<List<SearchData>, Map<String, dynamic>>(
        (ref, body) async {
      final provider = ref.read(searchResProvider);
      final service = ref.read(searchRestaurantService);
      try {
        final response = await service.searchRestaurant(body);
        provider.setRestaurant(response!);
        return response;
      } catch (e) {
        if (provider.context?.mounted ?? false) {
          Utils.showNetworkErrorToast(
            provider.context!,
            e.toString(),
          );
        }
        provider.setError(e.toString());
        return [];
      } finally {
        provider.setLoading(false);
      }
    });

final createAddressProvider =
FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.read(addressApiService);
  final signupState = ref.read(searchResProvider);

  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.CREATE_ADDRESS}';

  try {
    final responseData = await apiService.createAddressService(url, params, "");

    final message = responseData['message'];

    signupState.setLoading(false);

    if (signupState.context.mounted) {
      showCustomSnackBar(
        context: signupState.context!,
        message: "Address  created successfully",
        color: Colors.green,
      );


      Navigator.pop(signupState.context!);
    }
  } catch (e) {
    signupState.setLoading(false);

    if (signupState.context.mounted) {
      Utils.showNetworkErrorToast(
        signupState.context!,
        e.toString(),
      );
    }
  }
});

final editAddressProvider =
FutureProvider.family<void, Map<String, dynamic>>((ref, params) async {
  final apiService = ref.read(addressApiService);
  final signupState = ref.read(searchResProvider);

  final url = '${NetworkUrls.BASE_URL}${NetworkUrls.EDIT_ADDRESS}';

  try {
    final responseData = await apiService.createAddressService(url, params, "");

    final message = responseData['message'];

    signupState.setLoading(false);

    if (signupState.context.mounted) {
      showCustomSnackBar(
        context: signupState.context!,
        message: "Address updated successfully",
        color: Colors.green,
      );
      Navigator.pop(signupState.context!);
    }
  } catch (e) {
    signupState.setLoading(false);

    if (signupState.context.mounted) {
      Utils.showNetworkErrorToast(
        signupState.context!,
        e.toString(),
      );
    }
  }
});