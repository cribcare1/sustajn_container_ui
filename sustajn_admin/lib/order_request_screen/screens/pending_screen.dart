import 'package:container_tracking/order_request_screen/provider_service/order_request_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/card_widget.dart';
import '../../common_widgets/submit_clear_button.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../provider/order_provider.dart';
import '../../utils/nav_utils.dart';
import '../../utils/utility.dart';
import '../details_screen/pending_details_screen.dart';

class PendingScreen extends ConsumerStatefulWidget {
  const PendingScreen({super.key});

  @override
  ConsumerState<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends ConsumerState<PendingScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
     _getPendingOrderNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderRequestState = ref.watch(orderRequestProvider);
    Utils.printLog("item list = ${orderRequestState.getPendingDataList.length}");

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            ),
            SizedBox(height: Constant.SIZE_02),
            Expanded(
              child: orderRequestState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : orderRequestState.getPendingData == null
                  ? const Center(
                child: Text(
                  Strings.NO_CONTAINER_AVAILABLE,
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_16,
                    vertical: Constant.CONTAINER_SIZE_16
                ),
                itemCount: orderRequestState.getPendingDataList.length,
                itemBuilder: (context, index) {
                  final item = orderRequestState.getPendingDataList[index];
                  Utils.printLog("item = ${item.toString()}");
                  return pendingItemCard(
                    context,
                    orderId: item.id ?? 0,
                    requestNumber: item.requestNumber ?? "",
                    restaurantName: item.restaurantName ?? "-",
                    containerCodes: item.containerCodes ?? "-",
                    formattedDateTime: item.formattedDateTime ?? "-",
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
        required int orderId,
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
        NavUtil.navigateToPushScreen(context, PendingDetailsScreen(orderId: orderId));
      },
      child: GlassSummaryCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      Text(
                        containerCodes,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Constant.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
            Column(
              children: [
                Text(
                  "$totalQuantity",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: Constant.LABEL_TEXT_SIZE_14,
                    color: Colors.white70,
                  ),
                ),
              ],
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
            final orderState = ref.watch(orderProvider);
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

  _getPendingOrderNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderRequestProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          // final userId = Utils.userId;
          final url = '${NetworkUrls.PENDING_ORDER_DATA}';
          ref.read(getPendingOrderProvider(url));
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
