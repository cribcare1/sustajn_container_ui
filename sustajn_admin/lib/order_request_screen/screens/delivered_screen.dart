import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/card_widget.dart';
import '../../common_widgets/submit_button.dart';
import '../../common_widgets/submit_clear_button.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../provider/order_provider.dart';
import '../../utils/nav_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../details_screen/deliver_details_screen.dart';
import '../provider_service/order_request_provider.dart';

class DeliveredScreen extends ConsumerStatefulWidget {
  const DeliveredScreen({super.key});

  @override
  ConsumerState<DeliveredScreen> createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends ConsumerState<DeliveredScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getDeliverOrderNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderRequestState = ref.watch(orderRequestProvider);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: CustomTheme.searchField(
                searchController,
                Strings.SEARCH_BY_CONTAINER_NAME,
                onChanged: (value){
                  orderRequestState.filterInventoryByNameOrId(value);
                },
                //TODO:-
                onFilterTap: () => _showSortBottomSheet(context),
              ),
            ),
            SizedBox(height: Constant.SIZE_04),
            Expanded(
              child: orderRequestState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : orderRequestState.getDeliverData == null
                  ? const Center(
                child: Text(
                  Strings.NO_CONTAINER_AVAILABLE,
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : (orderRequestState.getDeliverDataList.isEmpty && searchController.text.isNotEmpty)
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Strings.NO_CONTAINER_AVAILABLE,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: Constant.LABEL_TEXT_SIZE_20),
                    SubmitButton(
                      onRightTap: () {
                        searchController.clear();
                        orderRequestState.filterInventoryByNameOrId('');
                        setState(() {});
                      },
                      rightText: " Clear Filter ",
                    ),
                  ],
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_16,
                    vertical: Constant.CONTAINER_SIZE_16
                ),
                itemCount: orderRequestState.getDeliverDataList.length,
                itemBuilder: (context, index) {
                  final item = orderRequestState.getDeliverDataList[index];

                  return pendingItemCard(
                    context,
                    id: item.id ?? 0,
                    requestNumber: item.requestNumber ?? "-",
                    restaurantName: item.restaurantName ?? "-",
                    containerCodes: item.containerCodes?.toString() ?? "0",
                    formattedDateTime : item.formattedDateTime?? "-",
                    totalQuantity: item.totalQuantity ?? 0,
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: Constant.CONTAINER_SIZE_10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pendingItemCard(
      BuildContext context, {
        required int id,
        required String requestNumber,
        required String restaurantName,
        required String containerCodes,
        required String formattedDateTime,
        required int totalQuantity,
        
      }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () {
        NavUtil.navigateToPushScreen(context, DeliverDetailsScreen(orderId: id));
      },
      child: GlassSummaryCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    requestNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Constant.LABEL_TEXT_SIZE_16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    restaurantName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: Constant.LABEL_TEXT_SIZE_14,
                      color: Colors.white70,
                    ),
                  ),

                  SizedBox(width: Constant.CONTAINER_SIZE_100),
                  Text(
                    containerCodes,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Constant.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_08),

                  Text(
                    formattedDateTime,
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
            Text(
              "$totalQuantity",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: Constant.LABEL_TEXT_SIZE_14,
                color: Colors.white70,
              ),
            ),
            SizedBox(width: Constant.SIZE_08),
            Icon(
              Icons.arrow_forward_ios,
              size: Constant.CONTAINER_SIZE_14,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            bool tempAscending = orderState.isQtyAscending;
            return SafeArea(
              top: false,
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return Container(
                    padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Constant.CONTAINER_SIZE_20),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Strings.SORT_BY,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Constant.CONTAINER_SIZE_18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(Icons.cancel_rounded, color: Constant.gold),
                            ),
                          ],
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Quantity : Low to High",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Radio<bool>(
                            value: true,
                            groupValue: tempAscending,
                            activeColor: Constant.gold,
                            fillColor: MaterialStateProperty.all(Constant.gold),
                            onChanged: (value) {
                              setModalState(() {
                                tempAscending = value!;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Quantity : High to Low",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Radio<bool>(
                            value: false,
                            groupValue: tempAscending,
                            activeColor: Constant.gold,
                            fillColor: MaterialStateProperty.all(Constant.gold),
                            onChanged: (value) {
                              setModalState(() {
                                tempAscending = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(height: Constant.CONTAINER_SIZE_20),
                        SubmitClearButton(
                          onLeftTap: () {
                            ref.read(orderProvider).resetSort();
                            Navigator.pop(context);
                          },
                          leftText: Strings.CLEAR,
                          onRightTap: () {
                            ref
                                .read(orderProvider)
                                .sortByQuantity(tempAscending);
                            Navigator.pop(context);
                          },
                          rightText: Strings.APPLY,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  _getDeliverOrderNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderRequestProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          // final userId = Utils.userId;
          final url = '${NetworkUrls.DELIVER_ORDER_DATA}';
          ref.read(getDeliverOrderProvider(url));
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
