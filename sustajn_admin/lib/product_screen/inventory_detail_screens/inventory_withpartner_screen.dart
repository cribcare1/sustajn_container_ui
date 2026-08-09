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
import '../models/withpartner_detail_data.dart';

class WithPartnerDetailsScreen extends ConsumerStatefulWidget {
  final int productId;

  const WithPartnerDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<WithPartnerDetailsScreen> createState() =>
      _WithPartnerDetailsScreenState();
}

class _WithPartnerDetailsScreenState
    extends ConsumerState<WithPartnerDetailsScreen> {
  // List<ExtendedFeeDataList> filteredList = [];

  String? selectedMonthYear;

  @override
  void initState() {
    super.initState();
    _getWithPartnerDetailNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);

    final partnerData = orderState.getWithPartnerDetailsData?.data;

    final partners = partnerData?.partners ?? [];

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,
      appBar: CustomAppBar(
        title: Strings.WITH_PARTNER,
        leading: const CustomBackButton(),
      ).getAppBar(context),
      body: Column(
        children: [
          _searchBar(),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: Constant.CONTAINER_SIZE_12),
              itemCount: partners.length,
              itemBuilder: (context, index) {
                return _partnerCard(partners[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      child: Container(
        height: Constant.CONTAINER_SIZE_50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Constant.green7, Constant.Green4],
          ),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          border: Border.all(color: Colors.white38),
        ),
        child: TextField(
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: Strings.SEARCH_BY_PARTNER_NAME,
            hintStyle: const TextStyle(color: Colors.white60),
            prefixIcon: const Icon(Icons.search, color: Colors.white60),
            suffixIcon: IconButton(
              onPressed: () {
                // Filter
              },
              icon: const Icon(Icons.filter_list, color: Colors.white60),
            ),
          ),
        ),
      ),
    );
  }

  Widget _partnerCard(Partners item) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_14,
        vertical: Constant.CONTAINER_SIZE_14,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Constant.green4,
            Constant.PrimaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Colors.white38),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.partnerName ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Constant.CONTAINER_SIZE_16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),

                Text(
                  item.address ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: Constant.CONTAINER_SIZE_13,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: Constant.CONTAINER_SIZE_10),

          Text(
            "${item.count ?? 0}",
            style: TextStyle(
              color: Constant.gold,
              fontWeight: FontWeight.bold,
              fontSize: Constant.CONTAINER_SIZE_22,
            ),
          ),
        ],
      ),
    );
  }

  _getWithPartnerDetailNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.WITH_PARTNER_DETAIL}${widget.productId}';
          ref.read(getWithPartnerDetailProvider(url));
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
