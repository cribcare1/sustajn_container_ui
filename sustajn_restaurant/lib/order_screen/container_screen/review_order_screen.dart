import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';

import '../../auth/screens/dashboard/dashboard_screen.dart';
import '../../common_widgets/submit_button.dart';
import '../../constants/imports_util.dart';
import '../../constants/string_utils.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/order_provider.dart';
import '../../utils/utility.dart';

class ReviewOrderScreen extends ConsumerWidget {
  const ReviewOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final theme = Theme.of(context);

    return SafeArea(
      bottom: true,top: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'Review Your Order',
            leading: CustomBackButton()).getAppBar(context),
        body: Stack(
          children: [

            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemCount: orderState.selectedContainers.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: Constant.CONTAINER_SIZE_12),
                      itemBuilder: (_, index) {
                        final item =
                        orderState.selectedContainers[index];

                        return Container(
                          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                          decoration: BoxDecoration(
                            color: Constant.grey.withOpacity(0.2),
                            borderRadius:
                            BorderRadius.circular(Constant.CONTAINER_SIZE_16),
                            border: Border.all(
                                color: Constant.grey.withOpacity(0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: Constant.CONTAINER_SIZE_60,
                                height: Constant.CONTAINER_SIZE_60,
                                decoration: BoxDecoration(
                                  color: Constant.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(
                                      Constant.CONTAINER_SIZE_12),
                                ),
                                child: Image.asset(
                                  "assets/images/cups.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(width: Constant.CONTAINER_SIZE_12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name!,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                          color: Colors.white),
                                    ),
                                    SizedBox(height: Constant.SIZE_04),
                                    Text(
                                      item.productId!,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                          color: Colors.white70),
                                    ),
                                    Text(
                                      "${item.capacityMl} ml",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                          color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      orderState.removeContainer(
                                          item.id!);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white70,
                                      size: Constant.CONTAINER_SIZE_18,
                                    ),
                                  ),
                                  SizedBox(height: Constant.CONTAINER_SIZE_20),
                                  Row(
                                    children: [
                                      _qtyBtn(
                                          context,
                                          Icons.remove,
                                              () {
                                            if (item.availableContainerCount! > 1) {
                                              item.availableContainerCount =
                                                  item.availableContainerCount! -
                                                      1;
                                              orderState
                                                  .notifyListeners();
                                            }
                                          }),

                                      Container(
                                        width:
                                        Constant.CONTAINER_SIZE_50,
                                        alignment:
                                        Alignment.center,
                                        child: Text(
                                          item.availableContainerCount
                                              .toString(),
                                          style: theme
                                              .textTheme.titleMedium
                                              ?.copyWith(
                                              color:
                                              Constant.gold),
                                        ),
                                      ),

                                      _qtyBtn(
                                          context,
                                          Icons.add,
                                              () {
                                            item.availableContainerCount =
                                                item.availableContainerCount! +
                                                    1;
                                            orderState
                                                .notifyListeners();
                                          }),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: SubmitButton(
                      rightText: 'Proceed to Confirm',
                      onRightTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          builder: (_) => ConfirmOrderSheet(
                            parentContext: context,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            if (orderState.isOrdering)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn(
      BuildContext context,
      IconData icon,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Constant.CONTAINER_SIZE_30,
        height: Constant.CONTAINER_SIZE_30,
        decoration: BoxDecoration(
          color: Constant.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(
              Constant.SIZE_08),
        ),
        child: Icon(icon,
            size: Constant.CONTAINER_SIZE_16,
            color: Colors.white),
      ),
    );
  }

}

class ConfirmOrderSheet extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  const ConfirmOrderSheet({super.key, required this.parentContext});

  @override
  ConsumerState<ConfirmOrderSheet> createState() =>
      _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState
    extends ConsumerState<ConfirmOrderSheet> {

  final TextEditingController remarks =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(
          Constant.CONTAINER_SIZE_20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
              Constant.CONTAINER_SIZE_30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            width: Constant.CONTAINER_SIZE_60,
            height: Constant.SIZE_04,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  Constant.SIZE_04),
            ),
          ),

          SizedBox(height:
          Constant.CONTAINER_SIZE_20),

          Container(
            padding: EdgeInsets.all(
                Constant.CONTAINER_SIZE_16),
            decoration: BoxDecoration(
              color:
              Constant.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                  Constant.CONTAINER_SIZE_16),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: Constant.gold,
              size: Constant.CONTAINER_SIZE_40,
            ),
          ),

          SizedBox(height:
          Constant.CONTAINER_SIZE_16),

          Text(
            "Confirm Order",
            style: theme.textTheme.titleLarge
                ?.copyWith(
                color: Colors.white),
          ),

          SizedBox(height:
          Constant.CONTAINER_SIZE_10),

          Text(
            "Please review your container types and quantities before confirming. This action cannot be changed later.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(
                color: Colors.white70),
          ),

          SizedBox(height:
          Constant.CONTAINER_SIZE_20),

          /// REMARKS
          Container(
            padding: EdgeInsets.all(
                Constant.CONTAINER_SIZE_12),
            decoration: BoxDecoration(
              color:
              Constant.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                  Constant.CONTAINER_SIZE_16),
            ),
            child: TextField(
              controller: remarks,
              maxLength: 500,
              maxLines: 4,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(
                  color: Colors.white),
              decoration: InputDecoration(
                hintText:
                "Remarks (optional)",
                hintStyle:
                TextStyle(
                    color:
                    Colors.white54),
                border: InputBorder.none,
                counterStyle:
                TextStyle(
                    color:
                    Colors.white54),
              ),
            ),
          ),

          SizedBox(height:
          Constant.CONTAINER_SIZE_20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  style:
                  OutlinedButton.styleFrom(
                    side: BorderSide(
                        color:
                        Constant.gold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_16,
                      ),
                    ),

                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color:
                        Constant.gold),
                  ),
                ),
              ),
              SizedBox(
                  width: Constant
                      .CONTAINER_SIZE_12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _placeOrder(
                        context, ref);
                  },
                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    Constant.gold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_16,
                      ),
                      side: BorderSide(color: Colors.white)
                    ),
                  ),

                  child: Text(
                    "Order",
                    style: theme
                        .textTheme.titleMedium
                        ?.copyWith(
                        color: theme
                            .primaryColor),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _placeOrder(
      BuildContext context,
      WidgetRef ref,
      ) async {
    final orderState = ref.read(orderProvider);

    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) async {
        try {
          if (isNetworkAvailable) {

            orderState.setContext(widget.parentContext);

            orderState.setIsLoading(true);
            orderState.setOrdering(true);

            final body = {
              "restaurantId": Utils.userId,
              "type": "BORROW",
              "items": orderState.selectedContainers
                  .map((e) => {
                "containerTypeId": e.id,
                "requestedQty": e.availableContainerCount,
              })
                  .toList(),
            };
print("=====++++===////___ :-  $body");
            await ref.read(addReturnProvider(body).future);

          } else {
            orderState.setIsLoading(false);
            orderState.setOrdering(false);

            if (!context.mounted) return;
            showCustomSnackBar(
              context: context,
              message: Strings.NO_INTERNET_CONNECTION,
              color: Colors.red,
            );
          }
        } catch (e) {
          Utils.printLog('Error on Order button: $e');
          orderState.setIsLoading(false);
          orderState.setOrdering(false);
        }

        if (!context.mounted) return;
        FocusScope.of(context).unfocus();
      });
    } catch (e) {
      Utils.printLog('Error in Order API: $e');
      orderState.setIsLoading(false);
      orderState.setOrdering(false);
    }
  }

}


