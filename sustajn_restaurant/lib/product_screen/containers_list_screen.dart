import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/provider/order_provider.dart';

import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../network_provider/network_provider.dart';
import '../utils/utility.dart';
import 'models/month_wise_history_model.dart';

class AssignedContainerListScreen extends ConsumerStatefulWidget {
  final String title;
  final String type;
  final int productId;

  const AssignedContainerListScreen({
    super.key,
    required this.title,
    required this.type,
    required this.productId,
  });

  @override
  ConsumerState<AssignedContainerListScreen> createState() =>
      _AssignedContainerListScreenState();
}

class _AssignedContainerListScreenState
    extends ConsumerState<AssignedContainerListScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getInventoryNetworkCall();
    });
    super.initState();
  }

  _getInventoryNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);
          final userId = Utils.userId;
          ref.read(
            getMonthWiseHistory({
              "restaurantId": userId,
              "productId": widget.productId,
              "type": widget.type,
            }),
          );
        } else {
          orderState.setIsLoading(false);
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      Utils.printLog('Error in visitor button onPressed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = ref.watch(orderProvider);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: widget.title,
        leading: CustomBackButton(),
      ).getAppBar(context),
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : provider.monthWiseDataList.isEmpty
          ? Center(
              child: Text(
                "Month wise History is not available",
                style: theme.textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
              itemCount: provider.monthWiseDataList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: Constant.CONTAINER_SIZE_16,
                        vertical: Constant.SIZE_10,
                      ),
                      color: Constant.grey.withOpacity(0.2),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              provider.monthWiseDataList[index].monthYear,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/img.png',
                                height: Constant.CONTAINER_SIZE_16,
                                width: Constant.CONTAINER_SIZE_16,
                                color: Constant.gold,
                              ),

                              SizedBox(width: Constant.SIZE_04),
                              Text(
                                provider
                                    .monthWiseDataList[index]
                                    .totalLeasedOrReturnCount
                                    .toString(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Constant.gold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ...provider.monthWiseDataList[index].dateLeasedReturnCounts
                        .map(
                          (item) => GestureDetector(
                            onTap: () {},
                            child: _listItem(context, item),
                          ),
                        ),
                  ],
                );
              },
              separatorBuilder: (context, index) =>
                  SizedBox(height: Constant.CONTAINER_SIZE_10),
            ),
    );
  }

  Widget _listItem(BuildContext context, DateLeasedReturnCounts item) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_16,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Constant.grey.withOpacity(0.4),
            width: Constant.SIZE_01,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(item.date),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: Constant.SIZE_04),
                Text(
                  _formatTime(item.date),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          Text(
            item.leasedReturnedCount.toString(),
            style: theme.textTheme.titleMedium?.copyWith(color: Constant.gold),
          ),
        ],
      ),
    );
  }

  String _formatDate(String apiDate) {
    try {
      final date = DateFormat("dd.MM.yyyy").parse(apiDate);
      return DateFormat("dd/MM/yyyy").format(date);
    } catch (e) {
      return apiDate;
    }
  }

  String _formatTime(String apiDate) {
    try {
      final date = DateFormat("dd.MM.yyyy").parse(apiDate);

      final hour = date.hour > 12
          ? date.hour - 12
          : date.hour == 0
          ? 12
          : date.hour;
      final period = date.hour >= 12 ? 'pm' : 'am';

      return "${hour.toString().padLeft(2, '0')}:"
          "${date.minute.toString().padLeft(2, '0')} $period";
    } catch (e) {
      return "";
    }
  }
}
