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
import 'models/issuedtopartner_model.dart';

class IssuedToPartnerScreenDetailsScreen extends ConsumerStatefulWidget {
  final int productId;

  const IssuedToPartnerScreenDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<IssuedToPartnerScreenDetailsScreen> createState() =>
      _IssuedToPartnerScreenDetailsScreenState();
}

class _IssuedToPartnerScreenDetailsScreenState
    extends ConsumerState<IssuedToPartnerScreenDetailsScreen> {
  String? selectedMonthYear;

  @override
  void initState() {
    super.initState();
    _getOrderDetailNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final issuedList = orderState.getIssuedToPartnerList;

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,
      appBar: CustomAppBar(
        title: Strings.ISSUED_PARTNER,
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
              itemCount: issuedList.length,
              itemBuilder: (context, index) {
                final month = issuedList[index];

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
                      itemCount: month.issuances?.length ?? 0,
                      itemBuilder: (_, i) {
                        return _issuedCard(month.issuances![i]);
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

  Widget _issuedCard(IssuedList item) {
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
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  item.restaurantName ?? "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: Constant.SIZE_05),

                Text(
                  item.restaurantAddress ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.65),
                    fontSize: Constant.CONTAINER_SIZE_13,
                  ),
                ),

                SizedBox(height: Constant.SIZE_08),

                Text(
                  item.deliveredDate ?? "",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.6),
                    fontSize: Constant.CONTAINER_SIZE_12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            "${item.quantity ?? 0}",
            style: TextStyle(
              color: Constant.gold,
              fontSize: Constant.CONTAINER_SIZE_24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_10),

          const Icon(Icons.chevron_right, color: Colors.white70),
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

  _getOrderDetailNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.ISSUED_TO_PARTNER}${widget.productId}';
          ref.read(getOrderDetailsProvider(url));
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
