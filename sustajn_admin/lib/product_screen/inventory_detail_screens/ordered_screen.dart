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
import 'models/ordered_data_model.dart';

class InventoryOrderDetailsScreen extends ConsumerStatefulWidget {
  final int productId;

  const InventoryOrderDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<InventoryOrderDetailsScreen> createState() =>
      _InventoryOrderDetailsScreenState();
}

class _InventoryOrderDetailsScreenState
    extends ConsumerState<InventoryOrderDetailsScreen> {
  String? selectedMonthYear;

  @override
  void initState() {
    super.initState();
    _getOrderDetailNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderProvider);
    final orderedList = orderState.getOrderedData;

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,
      appBar: CustomAppBar(
        title: Strings.ORDERED,
        leading: const CustomBackButton(),
      ).getAppBar(context),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: orderedList.length,
        itemBuilder: (context, index) {
          final month = orderedList[index];

          return Column(
            children: [
              _monthHeader(
                month.monthYear ?? "",
                (month.monthTotal ?? 0).toDouble(),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: month.dailyOrderd?.length ?? 0,
                itemBuilder: (_, i) => _orderedCard(month.dailyOrderd![i]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _orderedCard(DailyOrderd item) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        Constant.CONTAINER_SIZE_12,
        Constant.CONTAINER_SIZE_10,
        Constant.CONTAINER_SIZE_12,
        Constant.SIZE_08,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
        border: Border.all(color: Colors.white38),
        gradient: const LinearGradient(
          colors: [Constant.Green4, Constant.Green4],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Constant.CONTAINER_SIZE_14,
          vertical: Constant.CONTAINER_SIZE_12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.date ?? "",
              style: TextStyle(
                color: Colors.white,
                fontSize: Constant.CONTAINER_SIZE_15,
              ),
            ),
            Text(
              "${item.quantity ?? 0}",
              style: TextStyle(
                color: Constant.gold,
                fontWeight: FontWeight.bold,
                fontSize: Constant.CONTAINER_SIZE_18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _monthHeader(String title, double amount) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_14,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      color: Constant.green4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white70,
              fontSize: Constant.CONTAINER_SIZE_15,
            ),
          ),

          Row(
            children: [
              Image.asset(Strings.BOWL_IMG, height: Constant.CONTAINER_SIZE_15),

              SizedBox(width: Constant.SIZE_04),

              Text(
                amount.toStringAsFixed(0),
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

          final url = '${NetworkUrls.INVENTORY_ORDERED}${widget.productId}';
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
