import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/container_history_data.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/order_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  final searchController = TextEditingController();

  final Map<String, List<Map<String, dynamic>>> orders = {
    'December-2025': [
      {
        'title': 'Dip Cups-150',
        'orderId': '#ORD-00234',
        'date': 'Ordered on: 10/12/2025',
        'status': 'Pending',
      },
      {
        'title': 'Round Container-200',
        'orderId': '#ORD-00233',
        'date': 'Confirmed on: 01/12/2025',
        'status': 'Confirmed',
      },
    ],
    'November-2025': [
      {
        'title': 'Round Container-200, Dip Cup-15, ..',
        'orderId': '#ORD-00232',
        'date': 'Delivered on: 26/11/2025',
        'status': 'Delivered',
      },
      {
        'title': 'Rectangular Container-300',
        'orderId': '#ORD-00231',
        'date': 'Rejected on: 10/11/2025',
        'status': 'Rejected',
      },
    ],
  };

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

    final container =
        containerState.containerHistorydata?.data?.orderedResponses;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          child: Column(
            children: [
              CustomTheme.searchField(
                searchController,
                Strings.SEARCH_BY_CONTAINER_NAME,
              ),
              SizedBox(height: Constant.CONTAINER_SIZE_10),
              Expanded(
                child: containerState.isLoading
                    ? Center(child: CircularProgressIndicator())
                    : container == null
                    ? const Center(
                        child: Text(
                          Strings.NO_CONTAINER_AVAILABLE,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: container.length,
                        itemBuilder: (context, index) {
                          //todo needed later
                          // final month = container.elementAt(index);
                          // final monthOrders = container[month];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //todo needed later
                              // _buildMonthHeader(context, month),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: container.length,
                                separatorBuilder: (_, __) => SizedBox(
                                  height: Constant.CONTAINER_SIZE_12,
                                ),
                                itemBuilder: (context, orderIndex) {
                                  final item = container[index];
                                  return _buildOrderCard(
                                    context,
                                    item.status ?? "Unknown",
                                    item.productName ?? "N/A",
                                    item.orderId ?? "-",
                                    item.orderDate ?? "",
                                  );
                                },
                              ),
                            ],
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

  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      child: TextField(
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_CONTAINER_NAME,
          prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
          suffixIcon: Icon(Icons.tune, color: theme.iconTheme.color),
          filled: true,
          fillColor: theme.cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide.none,
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

    return Container(
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
          'Order ID: $orderId',
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
        SizedBox(height: Constant.SIZE_04),
        Text(
          date,
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
