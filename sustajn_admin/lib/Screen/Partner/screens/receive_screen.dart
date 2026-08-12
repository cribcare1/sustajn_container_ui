import 'package:container_tracking/Screen/Partner/screens/receive_details_dialogue.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/model/login_model.dart';
import '../../../common_provider/network_provider.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/theme_utils.dart';
import '../../../utils/utility.dart';
import '../model/container_history_data.dart';
import '../provider/notifier/product_notifier.dart';
import '../provider/provider/product_provider.dart';
import 'lease_filter_bottomsheet.dart';

class ReceiveScreen extends ConsumerStatefulWidget {
  final int? restaurantId;

  const ReceiveScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen> {
  final searchController = TextEditingController();

  String? selectedMonthYear;

  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final containerState = ref.read(productProvider);
      searchController.text = containerState.searchQueryReceive;
    });
    _loadProfile();
    _getReceiveNetworkCall();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerState = ref.watch(productProvider);

    final container =
        containerState.containerHistorydata?.data?.receivedResponses;

    return SafeArea(
      bottom: true,
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: CustomTheme.searchField(
                onChanged: (value) {
                  containerState.setSearchQueryReceive(value);
                },
                searchController,
                Strings.SEARCH_BY_CUSTOMERNAME,
                onFilterTap: () => _showFilterBottomSheet(context),
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_10),
            Expanded(
              child: containerState.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : (container == null || container.isEmpty)
                  ? const Center(
                      child: Text(
                        Strings.NO_CONTAINER_AVAILABLE,
                        style: TextStyle(color: Constant.white),
                      ),
                    )
                  : (containerState.groupedReceiveOrders.isEmpty)
                  ? _buildEmptyState(containerState)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.CONTAINER_SIZE_16,
                      ),
                      itemCount: containerState.groupedReceiveOrders.length,
                      itemBuilder: (context, index) {
                        String monthYear = containerState
                            .groupedReceiveOrders
                            .keys
                            .elementAt(index);
                        List<ReceivedResponses> orders =
                            containerState.groupedReceiveOrders[monthYear]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Constant.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(
                                  Constant.SIZE_06,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: Constant.CONTAINER_SIZE_10,
                                horizontal: Constant.CONTAINER_SIZE_10,
                              ),
                              margin: EdgeInsets.only(bottom: Constant.SIZE_08),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    monthYear,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontSize: Constant.LABEL_TEXT_SIZE_16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                        ),
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        Strings.BOWL_IMG,
                                        height: Constant.CONTAINER_SIZE_16,
                                        width: Constant.CONTAINER_SIZE_16,
                                      ),
                                      SizedBox(width: Constant.SIZE_06),
                                      Text(
                                        '${containerState.getMonthTotalReceive(orders)}',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: Constant.gold,
                                              fontSize:
                                                  Constant.LABEL_TEXT_SIZE_18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: orders.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: Constant.SIZE_08),
                              itemBuilder: (context, orderIndex) {
                                return _receiveCard(
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
            size: Constant.CONTAINER_SIZE_64,
            color: Constant.green5.withOpacity(0.3),
          ),
          SizedBox(height: Constant.CONTAINER_SIZE_16),
          Text(
            Strings.NO_ORDERS,
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: Constant.white),
          ),
        ],
      ),
    );
  }

  Widget _receiveCard(
    BuildContext context,
    ThemeData theme,
    ReceivedResponses data,
    OrderState containerState,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () => _openReceiveDialog(context, data),
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
              Text(
                containerState.formatProductIds(data.productOrderListResponses),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_16,
                  fontWeight: FontWeight.w600,
                  color: Constant.white3,
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
                        color: Constant.white3,
                      ),
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_08),
                  Text(
                    data.returnedQuantity.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Constant.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: Constant.CONTAINER_SIZE_14,
                    color: Constant.white3,
                  ),
                ],
              ),
              SizedBox(height: Constant.SIZE_06),
              Text(
                containerState.formatDateTime(data.returnDateTime ?? ""),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                  color: Constant.white3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openReceiveDialog(BuildContext context, ReceivedResponses data) {
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
            top: false,
            bottom: true,
            child: ReceiveDetailsDialogue(data: data),
          );
        },
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final containerState = ref.read(productProvider);
    final receivedResponses =
        containerState.containerHistorydata?.data?.receivedResponses;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return CommonFilterBottomSheet(
          items: receivedResponses!
              .map(
                (e) => FilterItem(
                  dateTime: e.returnDateTime ?? '',
                  products: e.productOrderListResponses,
                ),
              )
              .toList(),
          onApply: (selectedMonths, selectedContainers) {
            _applyFilters(selectedMonths, selectedContainers);
          },
        );
      },
    );
  }

  void _applyFilters(
    List<String> selectedMonths,
    List<String> selectedContainers,
  ) {
    final containerState = ref.read(productProvider);

    List<ReceivedResponses>? allResponses =
        containerState.containerHistorydata?.data?.receivedResponses;

    if (allResponses == null) return;

    if (selectedMonths.isEmpty && selectedContainers.isEmpty) {
      containerState.clearFiltersReceive();
      return;
    }

    List<ReceivedResponses> filteredResponses = allResponses.where((response) {
      bool matchesMonth = true;
      bool matchesContainer = true;

      if (selectedMonths.isNotEmpty) {
        String responseMonth = containerState.getMonthYearReceive(
          response.returnDateTime ?? '',
        );
        matchesMonth = selectedMonths.contains(responseMonth);
      }

      if (selectedContainers.isNotEmpty) {
        matchesContainer = false;
        if (response.productOrderListResponses != null) {
          for (var product in response.productOrderListResponses!) {
            if (selectedContainers.contains(product.productUniqueId)) {
              matchesContainer = true;
              break;
            }
          }
        }
      }

      return matchesMonth && matchesContainer;
    }).toList();

    containerState.applyFiltersReceive(filteredResponses);
  }

  _getReceiveNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(productProvider);
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
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }
}
