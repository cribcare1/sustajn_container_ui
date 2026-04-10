import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common_provider/network_provider.dart';
import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../provider/order_provider.dart';
import '../utils/utility.dart';

class AssignedContainerListScreen extends ConsumerStatefulWidget {
  final String title;
  final String type;
  final int productId;

  const AssignedContainerListScreen({
    super.key,
    required this.title,
    required this.type,
    required this.productId,
  });
  @override
  ConsumerState<AssignedContainerListScreen> createState() =>
      _AssignedContainerListScreenState();
}
class _AssignedContainerListScreenState
    extends ConsumerState<AssignedContainerListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInventoryNetworkCall();
    });
    super.initState();
  }
  _getInventoryNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final userId = Utils.userId;

        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}