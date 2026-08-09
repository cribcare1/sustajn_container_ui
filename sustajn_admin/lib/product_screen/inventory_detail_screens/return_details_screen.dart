import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_provider/network_provider.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/utility.dart';
import '../../common_widgets/custom_app_bar.dart';
import '../../common_widgets/custom_back_button.dart';
import '../../provider/order_provider.dart';
import 'models/return_model.dart';

class InventoryReturnDetailsScreen extends ConsumerStatefulWidget {
  final int productId;

  const InventoryReturnDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<InventoryReturnDetailsScreen> createState() =>
      _InventoryReturnDetailsScreenState();
}

class _InventoryReturnDetailsScreenState
    extends ConsumerState<InventoryReturnDetailsScreen> {
  String? selectedMonthYear;

  @override
  void initState() {
    super.initState();
    _getReturnDetailNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    final returnedData = orderState.getReturnedData;
    final returnList = returnedData?.data ?? [];

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,
      appBar: CustomAppBar(
        title: Strings.RETURNED,
        leading: const CustomBackButton(),
      ).getAppBar(context),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
            child: Container(
              height: Constant.CONTAINER_SIZE_45,
              decoration: BoxDecoration(
                color: Constant.green4,
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
                border: Border.all(color: Colors.white24),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Strings.SEARCH_BY_PARTNER_NAME,
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.6)),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  suffixIcon: const Icon(Icons.tune, color: Colors.white70),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: returnList.length,
              itemBuilder: (context, index) {
                final month = returnList[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _monthHeader(
                      month.monthYear ?? "",
                      month.totalQuantity ?? 0,
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: month.items?.length ?? 0,
                      itemBuilder: (context, i) {
                        return _returnCard(month.items![i]);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _returnCard(ReturnItems item) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Constant.CONTAINER_SIZE_16,
        Constant.SIZE_00,
        Constant.CONTAINER_SIZE_16,
        Constant.CONTAINER_SIZE_14,
      ),
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
      decoration: BoxDecoration(
        color: Constant.green4,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_18),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.18),
            blurRadius: Constant.CONTAINER_SIZE_10,
            offset: Offset(Constant.SIZE_00, Constant.SIZE_04),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.restaurantName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: Constant.SIZE_05),

                Text(
                  item.customerId ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.65),
                    fontSize: Constant.CONTAINER_SIZE_13,
                  ),
                ),

                SizedBox(height: Constant.SIZE_08),

                Text(
                  item.fullDateTime ?? "",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.6),
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_12),

          Text(
            "${item.soldQuantity ?? 0}",
            style: TextStyle(
              color: Constant.gold,
              fontSize: Constant.CONTAINER_SIZE_24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_10),

          Icon(
            Icons.chevron_right,
            color: Colors.white70,
            size: Constant.CONTAINER_SIZE_22,
          ),
        ],
      ),
    );
  }

  Widget _monthHeader(String month, int total) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Constant.CONTAINER_SIZE_16,
        Constant.SIZE_06,
        Constant.CONTAINER_SIZE_16,
        Constant.SIZE_08,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            month,
            style: TextStyle(
              color: Colors.white70,
              fontSize: Constant.CONTAINER_SIZE_16,
            ),
          ),

          Row(
            children: [
              Image.asset(Strings.BOWL_IMG, height: Constant.CONTAINER_SIZE_16),

              SizedBox(width: Constant.SIZE_04),

              Text(
                "$total",
                style: const TextStyle(
                  color: Constant.gold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _getReturnDetailNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.INV_RETURNED_DATA}${widget.productId}';
          ref.read(getReturnOrderProvider(url));
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
