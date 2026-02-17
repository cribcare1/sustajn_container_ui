import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sustajn_restaurant/common_widgets/submit_clear_button.dart';
import 'package:sustajn_restaurant/product_screen/receive_screen/receive_details.dart';

import '../../common_widgets/filter_Screen.dart';
import '../../constants/network_urls.dart';
import '../../constants/number_constants.dart';
import '../../constants/string_utils.dart';
import '../../models/login_model.dart';
import '../../network_provider/network_provider.dart';
import '../../provider/order_provider.dart';
import '../../utils/date_month_utils.dart';
import '../../utils/theme_utils.dart';
import '../../utils/utility.dart';
import '../product_filter.dart';

class ReceiveScreen extends ConsumerStatefulWidget {
  const ReceiveScreen({super.key});

  @override
  ConsumerState<ReceiveScreen> createState() => _ReceiveScreenState();
}

class _ReceiveScreenState extends ConsumerState<ReceiveScreen> {
  final searchController = TextEditingController();

  String? selectedMonthYear;

  LoginData? loginResponse;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _getReceiveNetworkCall();
  }

  Future<void> _loadProfile() async {
    await Utils.getProfile();
    setState(() {
      loginResponse = Utils.loginData?.data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final containerState = ref.watch(orderProvider);

    final container =
        containerState.containerHistorydata?.data?.receivedResponses;

    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              child: CustomTheme.searchField(
                searchController,
                Strings.SEARCH_BY_CONTAINER_NAME,
                onFilterTap: () => _showSortBottomSheet(context),
              ),
            ),
            SizedBox(height: Constant.CONTAINER_SIZE_16),
            Expanded(
              child: containerState.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : container == null || container.isEmpty
                  ? const Center(
                      child: Text(
                        Strings.NO_CONTAINER_AVAILABLE,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.separated(
                      itemCount: container.length,
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.CONTAINER_SIZE_16,
                      ),
                      separatorBuilder: (_, __) =>
                          SizedBox(height: Constant.SIZE_08),
                      itemBuilder: (context, index) {
                        final item = container[index];
                        return _receiveCard(
                          context,
                          theme,
                          item.transactionId!,
                          item.productsName!,
                          item.returnedQuantity!,
                          item.returnDateTime!,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiveCard(
    BuildContext context,
    ThemeData theme,
    String transactionId,
    String productName,
    int qty,
    String date,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_20),
      onTap: () => _openLeaseDialog(context, transactionId, date),
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.SIZE_08),
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
          border: Border.all(color: Constant.grey, width: 0.3),
        ),
        child: Padding(
          padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                transactionId,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: Constant.SIZE_06),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      productName ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: Constant.LABEL_TEXT_SIZE_14,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_08),
                  Text(
                    qty.toString(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Constant.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: Constant.CONTAINER_SIZE_14,
                    color: Colors.white70,
                  ),
                ],
              ),
              SizedBox(height: Constant.SIZE_06),
              Text(
                date ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLeaseDialog(
    BuildContext context,
    String transactionId,
    String date,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ReceiveDetailsDialog(transactionId: transactionId, dateTime: date),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    final containerState = ref.read(orderProvider);
    final container =
        containerState.containerHistorydata?.data?.receivedResponses;

    final months = DateMonthUtils.getCurrentYearMonths();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ProductFilter(
          title: Strings.FILTER,
          leftTabTitle: Strings.MONTH,
          options: months,
          selectedValue: selectedMonthYear,
          onApply: (value) {
            if (value == null) return;

            setState(() {
              selectedMonthYear = value as String?;

            });
          },
        );
      },
    );
  }


  _getReceiveNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final userId = Utils.userId;
          final url = '${NetworkUrls.CONTAINER_HISTORY}$userId';
          ref.read(getContainerHistoryProvider(url));
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
