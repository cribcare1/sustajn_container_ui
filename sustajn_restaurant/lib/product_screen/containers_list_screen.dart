import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sustajn_restaurant/common_widgets/card_widget.dart';
import 'package:sustajn_restaurant/common_widgets/custom_app_bar.dart';
import 'package:sustajn_restaurant/common_widgets/custom_back_button.dart';
import 'package:sustajn_restaurant/provider/order_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants/number_constants.dart';
import '../constants/string_utils.dart';
import '../network_provider/network_provider.dart';
import '../utils/utility.dart';
import 'models/history_graph_model.dart';
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
  _getGraphData(String date) async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        final orderState = ref.read(orderProvider);
        if (isNetworkAvailable) {
          orderState.setGraphLoading(true);
          final userId = Utils.userId;
          ref.read(
            getOrderGraphProvider({
              "restaurantId": userId,
              "productId": widget.productId,
              "type": widget.type,
              "date":date
            }),
          );
        } else {
          orderState.setGraphLoading(false);
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
    return SafeArea(
      top: false,bottom: true,
      child: Scaffold(
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
                              onTap: () {
                                _getGraphData(item.date);
                                _showGraphBottomSheet(context, item.date,item.leasedReturnedCount);
                              },
                              child: _listItem(context, item),
                            ),
                          ),
                    ],
                  );
                },
                separatorBuilder: (context, index) =>
                    SizedBox(height: Constant.CONTAINER_SIZE_10),
              ),
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

  void _showGraphBottomSheet(
      BuildContext context,
      String date,
      int count,
      ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_16),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(Constant.SIZE_08),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                        size: Constant.CONTAINER_SIZE_20,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Constant.CONTAINER_SIZE_30),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_20),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final orderState = ref.watch(orderProvider);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (widget.type == "RETURNED")
                                ? "Returned Details"
                                : "Leased Details",
                            style: TextStyle(
                              fontSize: Constant.LABEL_TEXT_SIZE_20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_16),
                          GlassSummaryCard(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        date,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: Constant.LABEL_TEXT_SIZE_16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(height: Constant.SIZE_04),
                                      Text(
                                        _getMonthName(date),
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: Constant.LABEL_TEXT_SIZE_14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      color: Color(0xFFFBBF24),
                                      size: Constant.CONTAINER_SIZE_18,
                                    ),
                                    SizedBox(width: Constant.SIZE_06),
                                    Text(
                                      count.toString(),
                                      style: TextStyle(
                                        color: Color(0xFFFBBF24),
                                        fontSize: Constant.LABEL_TEXT_SIZE_18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: Constant.CONTAINER_SIZE_20),
                          Expanded(
                            child: orderState.isGraphLoading
                                ? Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFFBBF24),
                              ),
                            )
                                : SfCartesianChart(
                              backgroundColor: Colors.transparent,
                              plotAreaBorderWidth: 0,
                              zoomPanBehavior: ZoomPanBehavior(
                                enablePanning: true,
                                enablePinching: true,
                                zoomMode: ZoomMode.x,
                              ),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                color: Colors.white.withOpacity(0.9),
                                textStyle: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: Constant.CONTAINER_SIZE_12,
                                ),
                              ),
                              primaryXAxis: CategoryAxis(
                                axisLine: AxisLine(
                                  width: 1,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                majorGridLines: MajorGridLines(width: 0),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: Constant.CONTAINER_SIZE_10,
                                ),
                                title: AxisTitle(
                                  text: 'Time (hours)',
                                  textStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Constant.CONTAINER_SIZE_12,
                                  ),
                                ),
                                // visibleMinimum: 0,
                                // visibleMaximum: 7,
                                autoScrollingDelta: 8,
                                autoScrollingMode: AutoScrollingMode.start,
                              ),
                              primaryYAxis: NumericAxis(
                                axisLine: AxisLine(width: 0),
                                majorTickLines: MajorTickLines(size: 0),
                                majorGridLines: MajorGridLines(
                                  width: 1,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: Constant.LABEL_TEXT_SIZE_14,
                                ),
                                title: AxisTitle(
                                  text: 'Containers',
                                  textStyle: TextStyle(
                                    color: Colors.white70,
                                    fontSize: Constant.CONTAINER_SIZE_12,
                                  ),
                                ),
                              ),
                              series: <CartesianSeries>[
                                ColumnSeries<HistoryGraphData, String>(
                                  dataSource: orderState.orderGraph,
                                  xValueMapper: (data, _) => data.time,
                                  yValueMapper: (data, _) =>
                                  data.leasedReturnedCount,
                                  enableTooltip: true,
                                  color: Color(0xFFFBBF24),
                                  borderRadius: BorderRadius.circular(
                                    Constant.SIZE_06,
                                  ),
                                  width: 0.6,
                                  spacing: 0.2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(String date) {
    try {
      List<String> parts = date.split('.');
      if (parts.length < 3) return '';

      int month = int.parse(parts[1]);
      List<String> monthNames = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      return monthNames[month - 1];
    } catch (e) {
      return '';
    }
  }



}
