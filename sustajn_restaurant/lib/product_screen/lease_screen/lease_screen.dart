import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';

import '../../common_widgets/filter_Screen.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/container_history_data.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../notifier/order_notifier.dart';
import '../../provider/order_provider.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import 'detail_dialo.dart';

class LeaseScreen extends ConsumerStatefulWidget {
  const LeaseScreen({super.key});

  @override
  ConsumerState<LeaseScreen> createState() => _LeaseScreenState();
}

class _LeaseScreenState extends ConsumerState<LeaseScreen> {
  final searchController = TextEditingController();

  bool _isQtyAscending = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerState = ref.read(orderProvider);
      searchController.text = containerState.searchQuery;
    });
    _getLeaseNetworkCall();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerState = ref.watch(orderProvider);
    final container =
        containerState.containerHistorydata?.data?.leasedResponses;

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: CustomTheme.searchField(
                onChanged: (value){
                  containerState.setSearchQuery(value);
                },
                searchController,
                Strings.SEARCH_BY_CONTAINER_NAME,
                onFilterTap: () => _showSortBottomSheet(context),
              ),
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
                  :

             (containerState.groupedOrders.isEmpty)
    ? _buildEmptyState(containerState)
    : ListView.builder(
               padding: EdgeInsets.symmetric(
                 horizontal: Constant.CONTAINER_SIZE_16,
               ),
               itemCount: containerState.groupedOrders.length,
               itemBuilder: (context, index) {
                 String monthYear = containerState.groupedOrders.keys.elementAt(index);
                 List<LeasedResponses> orders = containerState.groupedOrders[monthYear]!;

                 return Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     // Month Header with Total Count
                     Container(
                       padding: EdgeInsets.symmetric(
                         vertical: Constant.CONTAINER_SIZE_12,
                       ),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text(
                             monthYear,
                             style: theme.textTheme.titleMedium?.copyWith(
                               fontSize: Constant.LABEL_TEXT_SIZE_16,
                               fontWeight: FontWeight.w500,
                               color: Colors.white70,
                             ),
                           ),
                           Row(
                             children: [
                               Icon(
                                 Icons.inventory_2_outlined,
                                 color: Constant.gold,
                                 size: Constant.CONTAINER_SIZE_16,
                               ),
                               SizedBox(width: Constant.SIZE_06),
                               Text(
                                 '${containerState.getMonthTotal(orders)}',
                                 style: theme.textTheme.titleMedium?.copyWith(
                                   color: Constant.gold,
                                   fontSize: Constant.LABEL_TEXT_SIZE_18,
                                   fontWeight: FontWeight.w600,
                                 ),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ),

                     // Order Cards for this month
                     ListView.separated(
                       shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),
                       padding: EdgeInsets.zero,
                       itemCount: orders.length,
                       separatorBuilder: (_, __) => SizedBox(height: Constant.SIZE_08),
                       itemBuilder: (context, orderIndex) {
                         return _leaseCard(
                           context,
                           theme,
                           orders[orderIndex],
                           containerState,
                         );
                       },
                     ),
                     SizedBox(height: Constant.CONTAINER_SIZE_24),
                   ],
                 );
               },
             ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEmptyState(OrderState notifier) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Color(0xFF047857).withOpacity(0.3),
          ),
          SizedBox(height: 16),
          Text(
            'No orders found',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
  Widget _leaseCard(
      BuildContext context,
      ThemeData theme,
      LeasedResponses data,
      OrderState containerState,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () => _openLeaseDialog(
        context,
        data
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.SIZE_08),
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(color: Constant.grey, width: 0.3),
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Product IDs
              Text(
                containerState.formatProductIds(data.productOrderListResponses),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: Constant.SIZE_06),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order ID: #${data.orderId.toString().padLeft(8, '0')}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_08),
                  Text(
                    data.leasedQuantity.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Constant.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: Constant.CONTAINER_SIZE_14,
                    color: Colors.white70,
                  ),
                ],
              ),
              SizedBox(height: Constant.SIZE_06),
              Text(
                containerState.formatDateTime(data.leasedStartDateTime ?? ""),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLeaseDialog(
    BuildContext context,
      LeasedResponses data,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SafeArea(
              top: false,bottom: true,
              child: LeaseDetailsDialog(data: data));
        },
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    final containerState = ref.read(orderProvider);
    final container =
        containerState.containerHistorydata?.data?.leasedResponses;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ReusableFilterBottomSheet(
          title: Strings.SORT_BY,
          leftTabTitle: "Quantity",
          options: const [
            "Low to High",
            "High to Low",
          ],
          selectedValue: _isQtyAscending ? "Low to High" : "High to Low",
          onApply: (value) {
            if (container == null) return;

            setState(() {
              _isQtyAscending = value == "Low to High";

              container.sort(
                    (a, b) => _isQtyAscending
                    ? a.leasedQuantity!.compareTo(b.leasedQuantity!)
                    : b.leasedQuantity!.compareTo(a.leasedQuantity!),
              );
            });
          },
        );
      },
    );
  }


  _getLeaseNetworkCall() async {
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
