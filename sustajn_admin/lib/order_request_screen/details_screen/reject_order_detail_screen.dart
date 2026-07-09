import 'package:container_tracking/common_widgets/custom_app_bar.dart';
import 'package:container_tracking/constants/imports.util.dart';
import 'package:container_tracking/order_request_screen/models/reject_detail_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common_provider/network_provider.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../constants/network_urls.dart';
import '../../constants/string_utils.dart';
import '../../utils/no_data_custom_text.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../provider_service/order_request_provider.dart';
import '../screens/partner_remark_bottom_sheet.dart';

class RejectOrderDetailsScreen extends ConsumerStatefulWidget {
  final int orderId;

  const RejectOrderDetailsScreen({super.key, required orderId}) : orderId = orderId;

  @override
  ConsumerState<RejectOrderDetailsScreen> createState() =>
      _RejectDetailsScreenState();
}

class _RejectDetailsScreenState extends ConsumerState<RejectOrderDetailsScreen> {
  bool isClicked = false;

  @override
  void initState() {
    super.initState();
    _getRejectDetailsNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final orderRequestState = ref.watch(orderRequestProvider);
    final rejectDetailsData = orderRequestState.getRejectDetailsData;
    final themeData = CustomTheme.getTheme(false);

    return Scaffold(
      appBar: CustomAppBar(
        title: Strings.REJECT_DETAILS,
        leading: const CustomBackButton(),
      ).getAppBar(context),

      body: orderRequestState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (context != null)
          ? Padding(
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _restaurantDetails(
              themeData!,
              rejectDetailsData!.data!.restaurantName!,
              rejectDetailsData!.data!.restaurantAddress!,
            ),

            SizedBox(height: Constant.SIZE_18),

            _orderDetails(themeData, rejectDetailsData!.data!),

            SizedBox(height: Constant.SIZE_18),

            _sectionTitle(themeData),

            SizedBox(height: Constant.SIZE_18),

            Expanded(
              child: ListView.separated(
                itemCount: rejectDetailsData!.data!.items!.length,
                separatorBuilder: (_, __) =>
                    SizedBox(height: Constant.CONTAINER_SIZE_14),
                itemBuilder: (context, index) {
                  final item = rejectDetailsData!.data!.items![index];

                  return _containerItem(themeData, item);
                },
              ),
            ),
          ],
        ),
      )
          : NoDataFoundCustomText(text: "No Pending Details Found"),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: Constant.SIZE_02), // optional
                child: Image.asset(
                  "assets/icons/location.png",
                  width: Constant.CONTAINER_SIZE_16,
                  height: Constant.CONTAINER_SIZE_16,
                ),
              ),

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
      RejectedData rejectedData,
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
            child: Image.asset("assets/icons/order.png",
                width: Constant.CONTAINER_SIZE_18),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order ID",
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: Colors.white60,
                  ),
                ),

                SizedBox(height: Constant.SIZE_02),

                Text(
                  rejectedData.orderId!,
                  style: themeData.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_12),
                if (isClicked)
                  Padding(
                    padding: EdgeInsets.only(top: Constant.CONTAINER_SIZE_12, bottom: Constant.CONTAINER_SIZE_12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: Constant.CONTAINER_SIZE_28,
                              height: Constant.CONTAINER_SIZE_28,
                              decoration: const BoxDecoration(
                                color: Color(0xFF3DBE5A),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: Constant.CONTAINER_SIZE_18,
                              ),
                            ),

                            SizedBox(
                              width: Constant.SIZE_02,
                              height: Constant.CONTAINER_SIZE_45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                  6,
                                      (_) => Container(
                                    width: Constant.SIZE_02,
                                    height: Constant.SIZE_04,
                                        color: Color(0xFFDC3545),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: Constant.CONTAINER_SIZE_28,
                              height: Constant.CONTAINER_SIZE_28,
                              decoration: const BoxDecoration(
                                color: Color(0xFFDC3545),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: Constant.CONTAINER_SIZE_18,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(width: Constant.CONTAINER_SIZE_12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ordered on: ${rejectedData.orderedDate}",
                                style: themeData.textTheme.titleSmall,
                              ),
                              Text(
                                "Time: ${rejectedData.orderedTime}",
                                style: themeData.textTheme.bodySmall!.copyWith(
                                  color: Colors.white60,
                                ),
                              ),

                              SizedBox(height: Constant.CONTAINER_SIZE_30),

                              Text(
                                "Rejected on: ${rejectedData.rejectedDate}",
                                style: themeData.textTheme.titleSmall,
                              ),
                              Text(
                                "Time: ${rejectedData.rejectedTime}",
                                style: themeData.textTheme.bodySmall!.copyWith(
                                  color: Colors.white60,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        "Rejected Remarks",
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
        Text("Ordered Containers", style: themeData.textTheme.titleMedium),

        SizedBox(width: Constant.CONTAINER_SIZE_12),

        Expanded(child: Divider(color: const Color(0xffD9A91F), thickness: Constant.SIZE_01)),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Constant.SIZE_08),
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(
                  "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${item.imageUrl}",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Image.asset(Strings.CUP_IMG);
                  },
                )
                    : Image.asset(Strings.CUP_IMG),
              ),
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.containerName ?? "",
                  style: themeData.textTheme.titleMedium,
                ),

                SizedBox(height: Constant.SIZE_04),

                Text(
                  item.productCode ?? "",
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: Colors.white60,
                  ),
                ),

                SizedBox(height: Constant.SIZE_02),

                Text(
                  item.capacity ?? "",
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
              SizedBox(height: Constant.CONTAINER_SIZE_25),
              Text(
                " ${item.requestedQty ?? 0}",
                style: themeData.textTheme.bodySmall!.copyWith(
                  color: Colors.white60,
                ),
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
            SizedBox(width: Constant.CONTAINER_SIZE_12),
          ],
        ),
      ),
    );
  }

  _getRejectDetailsNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderRequestProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          // final userId = Utils.userId;
          final url =
              '${NetworkUrls.REJECT_ORDER_DETAILS_DATA}${widget.orderId}';
          ref.read(getRejectDetailProvider(url));
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
