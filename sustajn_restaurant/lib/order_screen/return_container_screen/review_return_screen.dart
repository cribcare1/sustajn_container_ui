import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../common_widgets/submit_button.dart';
import '../../constants/imports_util.dart';
import '../../constants/string_utils.dart';
import '../../models/get_container_data.dart';
import '../../network_provider/network_provider.dart';
import '../../notifier/order_notifier.dart';
import '../../provider/order_provider.dart';
import '../../utils/utility.dart';

class ReviewReturnScreen extends ConsumerWidget {
  const ReviewReturnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: "Review Your Order",
        leading: CustomBackButton(),
      ).getAppBar(context),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [

          Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount:
                    orderState.selectedContainers.length,
                    itemBuilder: (_, index) {
                      final item =
                      orderState.selectedContainers[index];

                      return _reviewCard(
                          context, item, orderState);
                    },
                  ),
                ),

                SubmitButton(
                  rightText: "Proceed to Confirm",
                  onRightTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => ConfirmReturnSheet(
                        parentContext: context,
                      ),
                    );
                  },
                )
              ],
            ),
          ),

          if (orderState.isOrdering)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _reviewCard(
      BuildContext context,
      ContainersDetails item,
      OrderState orderState,
      ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Constant.grey.withOpacity(0.2),
        borderRadius:
        BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Constant.grey.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          Container(
            width: Constant.CONTAINER_SIZE_60,
            height: Constant.CONTAINER_SIZE_60,
            decoration: BoxDecoration(
              color: Constant.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(
                Constant.CONTAINER_SIZE_12,
              ),
            ),
            child: Image.asset(
              "assets/images/cups.png",
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.containerName ?? "",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  item.containerUniqueId ?? "",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  "${item.capacity} ml",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              /// REMOVE
              GestureDetector(
                onTap: () {
                  orderState.removeContainer(item.containerId!);
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white70,
                  size: Constant.CONTAINER_SIZE_18,
                ),
              ),

              SizedBox(height: Constant.CONTAINER_SIZE_20),

              /// QTY STEPPER
              Row(
                children: [
                  _qtyBtn(context, Icons.remove, () {
                    if (item.quantityAvailable! > 1) {
                      item.quantityAvailable =
                          item.quantityAvailable! - 1;
                      orderState.notifyListeners();
                    }
                  }),

                  Container(
                    width: Constant.CONTAINER_SIZE_50,
                    alignment: Alignment.center,
                    child: Text(
                      item.quantityAvailable.toString(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Constant.gold,
                      ),
                    ),
                  ),

                  _qtyBtn(context, Icons.add, () {
                    item.quantityAvailable =
                        item.quantityAvailable! + 1;
                    orderState.notifyListeners();
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(
      BuildContext context,
      IconData icon,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Constant.CONTAINER_SIZE_30,
        height: Constant.CONTAINER_SIZE_30,
        decoration: BoxDecoration(
          color: Constant.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Constant.SIZE_08),
        ),
        child: Icon(
          icon,
          size: Constant.CONTAINER_SIZE_16,
          color: Colors.white,
        ),
      ),
    );
  }

}

class ConfirmReturnSheet extends ConsumerStatefulWidget {
  final BuildContext parentContext;
  const ConfirmReturnSheet({super.key, required this.parentContext});

  @override
  ConsumerState<ConfirmReturnSheet> createState() =>
      _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState
    extends ConsumerState<ConfirmReturnSheet> {

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
                    await _returnContainers(ref);
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

  Future<void> _returnContainers(WidgetRef ref) async {

    final orderState = ref.read(orderProvider);

    try {
      final isNetworkAvailable = await ref
          .read(networkProvider.notifier)
          .isNetworkAvailable();

      if (isNetworkAvailable) {

        orderState.setContext(widget.parentContext);
        orderState.setIsLoading(true);
        orderState.setOrdering(true);

        final body = {
          "restaurantId": Utils.userId,
          "type": "RETURN",
          "items": orderState.selectedContainers
              .map((e) => {
            "containerTypeId": e.containerId,
            "requestedQty": e.quantityAvailable,
          })
              .toList(),
        };

        await ref.read(addReturnProvider(body).future);

      } else {
        orderState.setOrdering(false);
        orderState.setIsLoading(false);

        showCustomSnackBar(
          context: widget.parentContext,
          message: Strings.NO_INTERNET_CONNECTION,
          color: Colors.red,
        );
      }
    } catch (e) {
      orderState.setOrdering(false);
      orderState.setIsLoading(false);
    }
  }


}
