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
import '../models/incirculation_detail_data.dart';

class IncirculationDetailsScreen extends ConsumerStatefulWidget {
  final int productId;

  const IncirculationDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<IncirculationDetailsScreen> createState() =>
      _IncirculationDetailsScreenState();
}

class _IncirculationDetailsScreenState
    extends ConsumerState<IncirculationDetailsScreen> {
  // List<ExtendedFeeDataList> filteredList = [];

  String? selectedMonthYear;

  @override
  void initState() {
    super.initState();
    _getIncirculationDetailNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final inCirculationData = orderState.getIncirculationDetailsData!.data!;
    final users = inCirculationData.users ?? [];

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,
      appBar: CustomAppBar(
        title: Strings.IN_CIRCULATION,
        leading: const CustomBackButton(),
      ).getAppBar(context),
      body: Column(
        children: [
          _searchBar(),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: Constant.CONTAINER_SIZE_12,
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return _orderedCard(users[index]);
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
            hintText: Strings.SEARCH_BY_USER_ID,
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

  Widget _orderedCard(Users item) {
    return Container(
      margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_10),
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_14,
        vertical: Constant.CONTAINER_SIZE_16,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Constant.green4, Constant.green4],
        ),
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Colors.white38),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.userId ?? "",
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_15,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "${item.count ?? 0}",
            style: TextStyle(
              color: Constant.gold,
              fontSize: Constant.CONTAINER_SIZE_20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _getIncirculationDetailNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.INCIRCULATION_DETAIL}${widget.productId}';
          // '${widget.userId}';
          ref.read(getIncirculationListProvider(url));
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
