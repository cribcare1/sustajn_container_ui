import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_button.dart';
import 'package:sustajn_restaurant/utils/utility.dart';

import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/get_container_data.dart';
import '../../provider/order_provider.dart';

class AddContainerDialog extends ConsumerStatefulWidget {
  final ContainersDetails item;

  const AddContainerDialog({super.key, required this.item});

  @override
  ConsumerState<AddContainerDialog> createState() => _AddContainerDialogState();
}

class _AddContainerDialogState extends ConsumerState<AddContainerDialog> {
  bool isEditingQty = false;
  final FocusNode qtyFocusNode = FocusNode();
  TextEditingController quantity = TextEditingController();
  int qty = 0;

  List<ContainersDetails> container = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    qty = 0;
    quantity.text = qty.toString();
    Utils.userId;
  }

  @override
  void dispose() {
    quantity.dispose();
    qtyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderState = ref.watch(orderProvider);

    return Padding(
      padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Constant.CONTAINER_SIZE_30),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Constant.CONTAINER_SIZE_60,
                  height: Constant.SIZE_05,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Constant.SIZE_05),
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),

                (widget.item.containerImageUrl != "")
                    ? Container(
                  height: Constant.CONTAINER_SIZE_60,
                  width: Constant.CONTAINER_SIZE_60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Image.network(
                    "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${widget.item.containerImageUrl}",
                    errorBuilder: (context, obj, stack) {
                      return Image.asset(
                        "assets/images/no_image_container.png",
                      );
                    },
                    fit: BoxFit.fill,
                  ),
                )
                    : Container(
                  width: Constant.CONTAINER_SIZE_70,
                  height: Constant.CONTAINER_SIZE_70,
                  decoration: BoxDecoration(
                    color: Constant.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(Constant.SIZE_08),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.inbox,
                      size: Constant.CONTAINER_SIZE_30,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: Constant.SIZE_15),

                Text(
                  widget.item.containerName!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.item.containerUniqueId!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "${widget.item.capacity!.toString()} ml",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: Constant.SIZE_15),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Constant.CONTAINER_SIZE_16,
                    vertical: Constant.SIZE_06,
                  ),
                  decoration: BoxDecoration(
                    color: Constant.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      Constant.CONTAINER_SIZE_10,
                    ),
                    border: Border.all(color: Constant.grey.withOpacity(0.4)),
                  ),
                  child: Text(
                    "In-Stock: ${widget.item.quantityAvailable}",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Constant.gold,
                    ),
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_20),

                Flexible(
                  flex: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(flex:2,
                        child: _qtyButton(
                          icon: Icons.remove,
                          onTap: () {
                            int currentQty = int.tryParse(quantity.text) ?? 0;

                            if (currentQty > 0) {
                              currentQty--;

                              setState(() {
                                qty = currentQty;
                                quantity.text = qty.toString();
                              });
                            }
                          },
                          theme: theme,
                        ),
                      ),
                      SizedBox(width: Constant.CONTAINER_SIZE_20),

                      Flexible(flex: 6,
                        child: Container(
                          width: Constant.CONTAINER_SIZE_100,
                          height: Constant.CONTAINER_SIZE_48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Constant.gold, width: 1.5),
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_12,
                            ),
                          ),
                          child:
                               TextField(
                                  controller: quantity,
                                  focusNode: qtyFocusNode,

                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  autofocus: false,
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                                  cursorColor: Colors.white,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                 onChanged: (value) {
                                   final enteredQty = int.tryParse(value) ?? 0;
                                   setState(() {
                                     qty = enteredQty;
                                   });
                                 },
                                  onSubmitted: (_) => _saveQty(),
                                  onEditingComplete: _saveQty,
                                )
                        ),
                      ),

                      SizedBox(width: Constant.CONTAINER_SIZE_20),
                      Flexible(flex: 2,
                        child: _qtyButton(
                          icon: Icons.add,
                          onTap: () {
                            int currentQty = int.tryParse(quantity.text) ?? 0;
                            if (currentQty < widget.item.quantityAvailable!) {
                              currentQty++;
                              setState(() {
                                qty = currentQty;
                                quantity.text = qty.toString();
                              });
                            }
                          },
                          theme: theme,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_25),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.amber, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Constant.CONTAINER_SIZE_16,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: Constant.CONTAINER_SIZE_12,
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Constant.gold),
                        ),
                      ),
                    ),
                    SizedBox(width: Constant.CONTAINER_SIZE_12),
                    Expanded(
                      child: SubmitButton(
                        onRightTap: () {
                          if (qty > 0) {
                            orderState.addContainerToOrder(widget.item, qty);
                            Navigator.pop(context);
                          }
                        },
                        rightText: Strings.ADD,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Constant.CONTAINER_SIZE_40,
        height: Constant.CONTAINER_SIZE_40,
        decoration: BoxDecoration(
          color: Constant.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  bool _toastShown = false;

  void _saveQty() {
    final int previousQty = qty;
    final int? value = int.tryParse(quantity.text);

    if (value == null || value > widget.item.quantityAvailable!) {
      if (!_toastShown) {
        Utils.showToast(
          "Quantity must be between 0 and ${widget.item.quantityAvailable}",
        );
        _toastShown = true;
        Future.delayed(Duration(seconds: 2), () => _toastShown = false);
      }

      setState(() {
        qty = previousQty;
        isEditingQty = false;
      });
      return;
    }

    setState(() {
      qty = value;
      isEditingQty = false;
    });
  }

}
