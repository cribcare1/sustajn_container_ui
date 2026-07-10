import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../provider_service/order_request_provider.dart';

class DeliverOrderSheet extends ConsumerStatefulWidget {
  const DeliverOrderSheet({super.key});

  @override
  ConsumerState<DeliverOrderSheet> createState() => _DeliverOrderSheetState();
}

class _DeliverOrderSheetState extends ConsumerState<DeliverOrderSheet> {
  final TextEditingController remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderRequestState = ref.watch(orderRequestProvider);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xff0D3C2D),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Constant.CONTAINER_SIZE_30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Constant.CONTAINER_SIZE_42,
              height: Constant.SIZE_05,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_28),
            Container(
              width: Constant.CONTAINER_SIZE_80,
              height: Constant.CONTAINER_SIZE_80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.05),
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                border: Border.all(
                  color: Colors.white.withOpacity(.12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xffD4AE37),
                  size: Constant.CONTAINER_SIZE_45,
                ),
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_26),

            Text(
              "Confirm Delivery",
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_14),

            Text(
              "Marking this order as delivered will complete the process and cannot be undone. "
                  "Confirm only if the containers have been physically delivered.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
                height: 1.5,
              ),
            ),

            SizedBox(height: Constant.CONTAINER_SIZE_30),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: Constant.CONTAINER_SIZE_45,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xffD6A62A),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xffD6A62A),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: Constant.CONTAINER_SIZE_14),

                Expanded(
                  child: SizedBox(
                    height: Constant.CONTAINER_SIZE_45,
                    child: ElevatedButton(
                      onPressed:  orderRequestState.isLoading
                          ? null
                          : () async {
                        await _getMarkDeliverOrderNetworkCall(orderRequestState.getPendingDetailsData!.data!.id!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffD6A62A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
                          side: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      child: const Text(
                        "Mark as Delivered",
                        style: TextStyle(
                          color: Color(0xff0F3727),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  _getPayLoad() {
    final orderRequestState = ref.watch(orderRequestProvider);
    final pendingDetailData = orderRequestState.getPendingDetailsData!.data!;
    var payload = {
      "orderId": pendingDetailData!.id!,
      "adminRemark": remarksController.text,
      "items": pendingDetailData.items!.map((item) {
        return {
          "itemId": item.itemId,
          "approvedQty": item.approvequantity,
        };
      }).toList(),
    };
    return payload;
  }

  _getMarkDeliverOrderNetworkCall(orderId) async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderRequestProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          orderState.setContext(context);
          final url =
              '${NetworkUrls.MARK_AS_DELIVERED}${orderId}';
          ref.read(getMarkDeliverOrderProvider(url));
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