import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../utils/utility.dart';
import '../provider_service/order_request_provider.dart';

class ConfirmOrderSheet extends ConsumerStatefulWidget {
  const ConfirmOrderSheet({super.key});

  @override
  ConsumerState<ConfirmOrderSheet> createState() => _ConfirmOrderSheetState();
}

class _ConfirmOrderSheetState extends ConsumerState<ConfirmOrderSheet> {
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderRequestState = ref.watch(orderRequestProvider);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.fromLTRB(Constant.CONTAINER_SIZE_24,
            Constant.CONTAINER_SIZE_16,
            Constant.CONTAINER_SIZE_24,
            Constant.CONTAINER_SIZE_24),
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
                    Icons.check,
                    color: Color(0xff2DBE60),
                    size: Constant.CONTAINER_SIZE_45,
                  ),
                ),
              ),
      
              SizedBox(height: Constant.CONTAINER_SIZE_26),
      
              Text(
                Strings.CONFIRM_ORDER,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      
              SizedBox(height: Constant.CONTAINER_SIZE_14),
      
              Text(
                Strings.CONFIRMATION,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
      
              SizedBox(height: Constant.CONTAINER_SIZE_24),
      
              TextField(
                controller: remarksController,
                maxLines: 5,
                maxLength: 500,
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  hintText: Strings.REMARK_OPTIONAL,
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  counterStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(.05),
                  contentPadding: EdgeInsets.all(Constant.CONTAINER_SIZE_18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(.12),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
                    borderSide: const BorderSide(
                      color: Color(0xffD6A62A),
                    ),
                  ),
                ),
              ),
      
              SizedBox(height: Constant.CONTAINER_SIZE_20),
      
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
                          Strings.CANCEL,
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
                        onPressed: orderRequestState.isLoading
                            ? null
                            : () async {
                          await _getApproveOrderNetworkCall();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffD6A62A),
                          disabledBackgroundColor: const Color(0xffD6A62A),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_15),
                            side: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        child: orderRequestState.isLoading
                            ?  SizedBox(
                          width: Constant.CONTAINER_SIZE_22,
                          height: Constant.CONTAINER_SIZE_22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                            : const Text(
                          Strings.CONFIRM_ORDER,
                          style: TextStyle(
                            color: Colors.black,
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

  _getApproveOrderNetworkCall() async {
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
              '${NetworkUrls.APPROVE_ORDER}';
          ref.read(getApproveOrderProvider(_getPayLoad()));
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

