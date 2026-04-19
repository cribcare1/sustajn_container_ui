import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/model/login_model.dart';
import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/theme_utils.dart';
import '../../../utils/utility.dart';
import '../model/container_history_data.dart';
import '../provider/provider/product_provider.dart';
import 'order_filter_bottomsheet.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  final int restaurantId;

  const OrderHistoryScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  final searchController = TextEditingController();
  List<OrderedResponses> filteredItems = [];

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

    final containerList =
        containerState.containerHistorydata?.data?.orderedResponses ?? [];

    if (filteredItems.isEmpty && containerList.isNotEmpty) {
      filteredItems = containerList;
    }
    Utils.printLog(
      "Order History Container Length: ${containerList?.length ?? 0}",
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: "Order History",
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            children: [
              CustomTheme.searchField(
                searchController,
                "Search by name or id",
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      filteredItems = containerList;
                    } else {
                      filteredItems = containerList.where((item) {
                        final search = value.toLowerCase();

                        final orderIdMatch =
                            item.orderId?.toString().toLowerCase().contains(
                              search,
                            ) ??
                            false;

                        final nameMatch =
                            item.productName?.toLowerCase().contains(search) ??
                            false;

                        return orderIdMatch || nameMatch;
                      }).toList();
                    }
                  });
                },
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const OrderFilterBottomSheet(),
                  );
                },
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_20),
              Expanded(
                child: containerState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (containerList == null || containerList.isEmpty)
                    ? Center(
                        child: Text(
                          Strings.NO_CONTAINER_AVAILABLE,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredItems.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: Constant.CONTAINER_SIZE_12),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];

                          return _buildOrderCard(
                            context,
                            item.status ?? "Unknown",
                            item.productName ?? "N/A",
                            item.orderId ?? "-",
                            item.orderDate ?? "",
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
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        // NavUtil.navigateToPushScreen(context, OrderDetailsScreen(
        //   orderId: orderId,
        //   status: status,
        // ));
      },
      child: Container(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          border: Border.all(color: Colors.white70),
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

    switch (status.toLowerCase()) {
      case 'pending':
        background = Color(0xFFFFDF99);
        textColor = Colors.black;
        break;
      case 'confirmed':
        background = Color(0xFFA5FF99);
        textColor = Colors.black;
        break;
      case 'delivered':
        background = Color(0xFF00DAF7);
        textColor = Colors.black;
        break;
      default:
        background = Color(0xFFFFB2BA);
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
          final url = '${NetworkUrls.CONTAINER_HISTORY}${widget.restaurantId}';
          ref.read(getContainerHistoryProvider(url));
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error button onPressed: $e');
    }
  }
}
