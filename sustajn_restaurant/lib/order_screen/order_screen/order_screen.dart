import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/container_history_data.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/order_provider.dart';
import '../../utils/nav_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import 'order_details_screen.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  final searchController = TextEditingController();

  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _getContaineHistoryCall();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerState = ref.watch(orderProvider);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: containerState.isLoading
              ? Center(child: CircularProgressIndicator())
              : (containerState.orderHistoryList.isEmpty)
              ? const Center(
                  child: Text(
                    Strings.NO_CONTAINER_AVAILABLE,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Column(
                  children: [
                    CustomTheme.searchField(
                      searchController,
                      "Search by Container Id/Order Id",
                      onChanged: (value) {
                        containerState.historyFilter(value);
                      },
                      //TODO:-
                      // onFilterTap: (){
                      //   showModalBottomSheet(
                      //     context: context,
                      //     isScrollControlled: true,
                      //     backgroundColor: Colors.transparent,
                      //     builder: (_) => const OrderFilterBottomSheet(),
                      //   );
                      //
                      // }
                    ),
                    SizedBox(height: Constant.CONTAINER_SIZE_10),
                    (containerState.orderHistoryListFiltered.isEmpty)
                        ? const Center(
                            child: Text(
                              Strings.NO_CONTAINER_AVAILABLE,
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: containerState
                                  .orderHistoryListFiltered
                                  .length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: Constant.CONTAINER_SIZE_12),
                              itemBuilder: (context, index) {
                                final item = containerState
                                    .orderHistoryListFiltered[index];
                                return _buildOrderCard(
                                  context,
                                  item.status ?? "Unknown",
                                  item.productName ?? "N/A",
                                  item.orderId ?? "-",
                                  item.orderDate ?? "",
                                  item,
                                );
                              },
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }

  // 🗓 Month Header
  Widget _buildMonthHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.SIZE_08,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    String status,
    String title,
    String orderId,
    String date,
    OrderedResponses orderData,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        NavUtil.navigateToPushScreen(
          context,
          OrderDetailsScreen(
            orderId: orderId,
            status: status,
            orderData: orderData,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          border: Border.all(color: Constant.grey.withOpacity(0.2)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildOrderDetails(context, title, orderId, date)),
            SizedBox(width: Constant.CONTAINER_SIZE_12),
            _buildStatusChip(context, status),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetails(
    BuildContext context,
    String title,
    String orderId,
    String date,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: Constant.SIZE_04),
        Text(
          'Order ID: #$orderId',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
        SizedBox(height: Constant.SIZE_04),
        Text(
          'Confirmed on: ${date}',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    final theme = Theme.of(context);

    Color background;
    Color textColor;

    switch (status) {
      case 'Pending':
        background = Constant.lightYellow;
        textColor = Colors.black;
        break;
      case 'Confirmed':
        background = Constant.lightGreen;
        textColor = Colors.black;
        break;
      case 'Delivered':
        background = Constant.lightBlue;
        textColor = Colors.black;
        break;
      default:
        background = Constant.lightPink;
        textColor = Colors.black;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_12,
        vertical: Constant.SIZE_06,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelSmall?.copyWith(color: textColor),
      ),
    );
  }

  _getContaineHistoryCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final userId = Utils.userId;
          final url = '${NetworkUrls.CONTAINER_HISTORY}$userId';
          ref.read(getContainerHistoryProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }
}
