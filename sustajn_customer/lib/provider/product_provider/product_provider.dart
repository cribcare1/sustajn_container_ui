import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sustajn_customer/provider/product_provider/product_notifier.dart';
import 'package:sustajn_customer/service/product_serivice.dart';

import '../../utils/utils.dart';

final productProvider = ChangeNotifierProvider((ref) => ProductNotifier());

final borrowedProvider = FutureProvider.family<dynamic, String>((
  ref,
  params,
) async {
  final productState = ref.watch(productProvider);
  try {
    var serviceProvider = ref.read(productServiceProvider);
    Utils.printLog("params===$params");
    var responseData = await serviceProvider.productService(params);
    if (responseData.status != null && responseData.status!.isNotEmpty) {
      productState.setIsLoading(false);
      productState.setProductData(responseData);
    } else {
      productState.setIsLoading(false);
      Utils.showToast(responseData.message!);
    }
  } catch (e) {
    Utils.printLog("Get product provider error called: $e");
    productState.setIsLoading(false);
    Utils.showNetworkErrorToast(productState.context, e.toString());
  }
});
