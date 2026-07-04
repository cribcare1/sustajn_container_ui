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

      body: orderRequestState.isLoading?const Center(child: CircularProgressIndicator()):(pendingDetails != null)?Padding(
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

            _orderDetails(themeData, pendingDetails!.data!),

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

                  return _containerItem(
                    themeData,
                    image: item.imageUrl!,
                    title: item.containerName!,
                    code: item.productCode!,
                    size: item.capacity!,
                    qty: item.orderedQty!,
                  );
                },
              ),
            ),
          ],
        ),
      ):NoDataFoundCustomText(text:"No Pending Details Found"),
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
        borderRadius: BorderRadius.circular(16),
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
              Image.asset("assets/icons/location.png", width: 16, height: 16),

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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white24),
            ),
            child: Image.asset("assets/icons/order.png", width: 18),
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

                SizedBox(height: 2),

                Text(
                  pendingDetailsData.orderId!,
                  style: themeData.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: Constant.CONTAINER_SIZE_12),
                (isClicked)? Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    Column(children: [
                      Text(
                        "Order On: 27.07.26",
                        style: themeData.textTheme.bodySmall!.copyWith(
                          color: Colors.white60,
                        ),
                      ),
                      SizedBox(width: Constant.CONTAINER_SIZE_12),
                      Text(
                      'Time: 11:00',
                        style: themeData.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],)
                  ],
                ):Container(),
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 0.1),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffD9A91F),
                          width: 1.5,
                        ),
                      ),
                    ),
                    child: Text(
                      "Partner Remarks",
                      style: themeData.textTheme.bodySmall!.copyWith(
                        color: const Color(0xffD9A91F),
                        decoration: TextDecoration.none,
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

        Expanded(child: Divider(color: const Color(0xffD9A91F), thickness: 1)),
      ],
    );
  }

  Widget _containerItem(
    ThemeData themeData, {
    required String image,
    required String title,
    required String code,
    required String size,
    required int qty,
  }) {
    return Container(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
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
                  child: image != null && image.isNotEmpty
                      ? Image.network(
                          "${NetworkUrls.CONTAINER_IMAGE_BASE_URL}${image}",
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
                Text(title, style: themeData.textTheme.titleMedium),

                SizedBox(height: Constant.SIZE_04),

                Text(
                  code,
                  style: themeData.textTheme.bodySmall!.copyWith(
                    color: Colors.white60,
                  ),
                ),

                SizedBox(height: Constant.SIZE_02),

                Text(
                  size,
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
                "Ordered Qty.",
                style: themeData.textTheme.bodySmall!.copyWith(
                  color: Colors.white60,
                ),
              ),

              SizedBox(height: Constant.SIZE_04),

              Text(
                qty.toString(),
                style: themeData.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: const Color(0xffD9A91F)),
            ),
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
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
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
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffD9A91F),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    Strings.CONFIRM_ORDER,
                    style: TextStyle(fontWeight: FontWeight.w600),
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
          // final userId = Utils.userId;
          final url = '${NetworkUrls.PENDING_ORDER_DETAILS_DATA}${widget.orderId}';
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
