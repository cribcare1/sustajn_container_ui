import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/network_urls.dart';
import '../../constants/string_utils.dart';
import '../../utils/no_data_custom_text.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../models/pending_detail_data.dart';
import '../provider_service/order_request_provider.dart';
import '../screens/confirm_order_sheet.dart';
import '../screens/partner_remark_bottom_sheet.dart';
import '../screens/reject_order_sheet.dart';

class PendingDetailsScreen extends ConsumerStatefulWidget {
  final int orderId;

  const PendingDetailsScreen({super.key, required orderId}) : orderId = orderId;

  @override
  ConsumerState<PendingDetailsScreen> createState() =>
      _PendingDetailsScreenState();
}

class _PendingDetailsScreenState extends ConsumerState<PendingDetailsScreen> {
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    _getPendingDetailsNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final orderRequestState = ref.watch(orderRequestProvider);
    final pendingDetails = orderRequestState.getPendingDetailsData;
    final themeData = CustomTheme.getTheme(false);

    return Scaffold(
      appBar: CustomAppBar(
        title: Strings.ORDER_DETAILS,
        leading: const CustomBackButton(),
      ).getAppBar(context),

      body: orderRequestState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (pendingDetails != null)
          ? Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _restaurantDetails(
                    themeData!,
                    pendingDetails!.data!.restaurantName!,
                    pendingDetails!.data!.restaurantAddress!,
                  ),

                  SizedBox(height: Constant.SIZE_18),

                  _orderDetails(themeData,
                      pendingDetails!.data!),

                  SizedBox(height: Constant.SIZE_18),

                  _sectionTitle(themeData),

                  SizedBox(height: Constant.SIZE_18),

                  Expanded(
                    child: ListView.separated(
                      itemCount: pendingDetails.data!.items!.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(height: Constant.CONTAINER_SIZE_14),
                      itemBuilder: (context, index) {
                        final item = pendingDetails.data!.items![index];

                        return _containerItem(themeData, item);
                      },
                    ),
                  ),
                ],
              ),
            )
          : NoDataFoundCustomText(text: Strings.NO_PENDING_DETAILS),
      bottomNavigationBar: _bottomButtons(themeData!),
    );
  }

  Widget _restaurantDetails(
    ThemeData themeData,
    String restaurantName,
    String address,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            restaurantName,
            style: themeData.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: Constant.SIZE_10),

          Row(
            children: [
              Image.asset("assets/icons/location.png",
                  width: Constant.CONTAINER_SIZE_16,
                  height: Constant.CONTAINER_SIZE_16),

              SizedBox(width: Constant.SIZE_08),

              Expanded(
                child: Text(
                  address,
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderDetails(
    ThemeData themeData,
    PendingDetailData pendingDetailsData,
  ) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: Constant.CONTAINER_SIZE_36,
            height: Constant.CONTAINER_SIZE_36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constant.SIZE_08),
              border: Border.all(color: Colors.white24),
            ),
            child: Image.asset("assets/icons/order.png", width: Constant.CONTAINER_SIZE_18),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.ORDER_ID,
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: Colors.white60,
                  ),
                ),

                SizedBox(height: Constant.SIZE_02),

                Text(
                  pendingDetailsData.orderId!,
                  style: themeData.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_12),
                (isClicked)
                    ? Row(
                        children: [
                          Container(
                            width: Constant.CONTAINER_SIZE_30,
                            height: Constant.CONTAINER_SIZE_30,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: Constant.CONTAINER_SIZE_18,
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                "Order On: 27.07.26",
                                style: themeData.textTheme.bodySmall!.copyWith(
                                  color: Colors.white60,
                                ),
                              ),
                              SizedBox(width: Constant.CONTAINER_SIZE_12),
                              Text(
                                'Time: 11:00',
                                style: themeData.textTheme.titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                Center(
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => const PartnerRemarksBottomSheet(),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(bottom: Constant.SIZE_02),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffD9A91F),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: Text(
                        Strings.PARTNER_REMARKS,
                        style: themeData.textTheme.bodySmall!.copyWith(
                          color: const Color(0xffD9A91F),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                isClicked = !isClicked;
              });
            },
            icon: Icon(isClicked ? Icons.arrow_drop_up : Icons.arrow_drop_down),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(ThemeData themeData) {
    return Row(
      children: [
        Text(Strings.ORDERED_CONTAINERS, style: themeData.textTheme.titleMedium),

        SizedBox(width: Constant.CONTAINER_SIZE_12),

        Expanded(child: Divider(color: const Color(0xffD9A91F), thickness: 1)),
      ],
    );
  }

  Widget _containerItem(ThemeData themeData, Items item) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: Constant.CONTAINER_SIZE_55,
                height: Constant.CONTAINER_SIZE_55,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.05),
                  borderRadius: BorderRadius.circular(Constant.SIZE_08),
                ),
                child: Padding(
                  padding: EdgeInsets.all(Constant.SIZE_08),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                      border: Border.all(color: Color(0xFFF5EBDF)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Constant.CONTAINER_SIZE_12,
                      ),
                      child:
                          item!.imageUrl! != null && item.imageUrl!.isNotEmpty
                          ? Image.network(
                              "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${item.imageUrl}",
                              width: Constant.CONTAINER_SIZE_60,
                              height: Constant.CONTAINER_SIZE_60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Strings.CUP_IMG,
                                  width: Constant.CONTAINER_SIZE_60,
                                  height: Constant.CONTAINER_SIZE_60,
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              Strings.CUP_IMG,
                              width: Constant.CONTAINER_SIZE_60,
                              height: Constant.CONTAINER_SIZE_60,
                            ),
                    ),
                  ),
                ),
              ),

              SizedBox(width: Constant.CONTAINER_SIZE_12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.containerName!,
                      style: themeData.textTheme.titleMedium,
                    ),

                    SizedBox(height: Constant.SIZE_04),

                    Text(
                      item.productCode!,
                      style: themeData.textTheme.bodySmall!.copyWith(
                        color: Colors.white60,
                      ),
                    ),

                    SizedBox(height: Constant.SIZE_02),

                    Text(
                      item.capacity!,
                      style: themeData.textTheme.bodySmall!.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Strings.ORDERED_QTY,
                    style: themeData.textTheme.bodySmall!.copyWith(
                      color: Colors.white60,
                    ),
                  ),

                  SizedBox(height: Constant.SIZE_04),

                  Text(
                    item.orderedQty!.toString(),
                    style: themeData.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              SizedBox(width: Constant.CONTAINER_SIZE_12),

              Checkbox(
                value: item.isClicked,
                onChanged: (bool? value) {
                  setState(() {
                    item.isClicked = value ?? false;
                  });
                },
              ),
            ],
          ),
          if (item.isClicked ?? false)
            Column(
              children: [
                 Divider(
                  color: Color(0xFF9E9E9E),
                  thickness: Constant.SIZE_01,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Qty.',
                      style: themeData.textTheme.bodySmall!.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Approve Qty.',
                          style: themeData.textTheme.bodySmall!.copyWith(
                            color: Colors.white60,
                          ),
                        ),
                        SizedBox(height: Constant.SIZE_08),

                        Text(
                          item.approvequantity!.toString(),
                          style: themeData.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          height: Constant.CONTAINER_SIZE_36,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white30),
                            borderRadius: BorderRadius.circular(Constant.SIZE_06),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove, size: Constant.CONTAINER_SIZE_18),
                                onPressed: () {
                                  setState(() {
                                    if (item.approvequantity! > 0) {
                                      item.approvequantity =
                                          item.approvequantity! - 1;
                                    }
                                  });
                                },
                              ),

                              SizedBox(
                                width: Constant.CONTAINER_SIZE_35,
                                child: Center(
                                  child: Text('${item.approvequantity}'),
                                ),
                              ),

                              IconButton(
                                icon: Icon(Icons.add, size: Constant.CONTAINER_SIZE_18),
                                onPressed: () {
                                  setState(() {
                                    item.approvequantity =
                                        item.approvequantity! + 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _bottomButtons(ThemeData themeData) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: Constant.CONTAINER_SIZE_45,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Constant.CONTAINER_SIZE_30),
                        ),
                      ),
                      builder: (_) => const RejectOrderSheet(),
                    );
                  },
                  child: const Text(
                    Strings.REJECT_ORDER,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

            SizedBox(width: Constant.CONTAINER_SIZE_12),

            Expanded(
              child: SizedBox(
                height: Constant.CONTAINER_SIZE_45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD9A91F),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                    ),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(Constant.CONTAINER_SIZE_30),
                        ),
                      ),
                      builder: (_) => const ConfirmOrderSheet(),
                    );
                  },
                  child: const Text(
                    Strings.CONFIRM_ORDER,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getPendingDetailsNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderRequestProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final url =
              '${NetworkUrls.PENDING_ORDER_DETAILS_DATA}${widget.orderId}';
          ref.read(getPendingDetailsProvider(url));
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
