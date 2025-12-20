import 'package:container_tracking/customer/customer_services.dart';
import 'package:container_tracking/customer/customer_state.dart';
import 'package:container_tracking/customer/model/customer_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../constants/network_urls.dart';
import '../utils/utility.dart';

final customerNotifierProvider = ChangeNotifierProvider<CustomerState>(
      (ref) => CustomerState(),
);

final fetchCustomerProvider = FutureProvider.family<void, bool>((ref, isLoadMore) async {
  final apiService = ref.read(customerApiProvider);
  final state = ref.read(customerNotifierProvider);

  // if (state.isLoading || state.isMoreLoading || !state.hasMore) return;
  //
  // isLoadMore ? state.setMoreLoading(true) : state.setLoading(true);

  Future.microtask((){
    state.setLoading(true);
  });

  final url =
      '${NetworkUrls.BASE_URL}${NetworkUrls.CUSTOMER_LIST}'
      'page=${state.page}&size=${state.size}';

  try {
    CustomerListModel response = await apiService.fetchCustomer(url);

    state.setCustomer(response.customersData);
    state.incrementPage();

  } catch (e) {
    state.setError(e.toString());

    if (state.context?.mounted ?? false) {
      showCustomSnackBar(
        context: state.context!,
        message: e.toString(),
        color: Colors.red,
      );
    }
  } finally {
    Future.microtask((){
      state.setLoading(false);
      state.setMoreLoading(false);
    });

  }
});

