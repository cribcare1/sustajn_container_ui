import 'package:container_tracking/transactions/models/transaction_extendedfee_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/filter_screen_2.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/date_month_utils.dart';
import '../../../utils/utility.dart';
import '../provider_service/transaction_provider.dart';

class TransactionExtendedFeeScreen extends ConsumerStatefulWidget {
  final int userId;

  const TransactionExtendedFeeScreen({super.key, required this.userId});

  @override
  ConsumerState<TransactionExtendedFeeScreen> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState
    extends ConsumerState<TransactionExtendedFeeScreen> {
  List<ExtendedFeeDataList> filteredList = [];
  final searchController = TextEditingController();
  String _searchQuery = '';
  String? selectedMonthYear;

  @override
  void initState() {
    super.initState();
    _getExtendedNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    final damageList = transactionState.getExtendedFeeDataList;
    Utils.printLog("damageList = ${damageList.length}");
    if (filteredList.isEmpty && damageList.isNotEmpty) {
      applySearchAndFilter(damageList);
    }

    return Scaffold(
      backgroundColor: Constant.PrimaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              _searchBar(),

              Expanded(
                child: filteredList.isEmpty && !transactionState.isLoading
                    ? Center(
                        child: Utils.getErrorText(
                          Strings.NO_TRANSACTION_EXTENDED_FEE_DATA,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final extendedData = filteredList.elementAt(index);

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _monthHeader(
                                extendedData.monthYear ?? '',
                                (extendedData.monthTotalAmount ?? 0).toDouble(),
                              ),

                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    extendedData.transactions?.length ?? 0,
                                itemBuilder: (_, i) {
                                  final transaction =
                                      extendedData.transactions![i];
                                  return _cardItem(transaction);
                                },
                              ),
                            ],
                          );
                        },
                      ),
              ),
            ],
          ),

          if (transactionState.isLoading)
            const Center(
              child: CircularProgressIndicator(color: Constant.gold),
            ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            applySearchAndFilter(
              ref.read(transactionProvider).getExtendedFeeDataList,
            );
          });
        },
        cursorColor: Constant.white,
        style: TextStyle(color: Constant.white),
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_EXTENDED_FEE,
          hintStyle: const TextStyle(color: Constant.PrimaryDarkColor),
          prefixIcon: const Icon(Icons.search, color: Constant.PrimaryDarkColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide(color: Constant.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
            borderSide: BorderSide(color: Constant.grey),
          ),
          fillColor: Constant.grey.withOpacity(0.1),
          filled: true,
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list, color: Constant.white),
            onPressed: () {
              final months = DateMonthUtils.getCurrentYearMonths();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => ReusableFilterBottomSheet(
                  title: Strings.FILTERS,
                  leftTabTitle: Strings.MONTH,
                  options: months,
                  selectedValue: selectedMonthYear,
                  onApply: (value) {
                    if (value == null) return;

                    setState(() {
                      selectedMonthYear = value;
                      applySearchAndFilter(
                        ref.read(transactionProvider).getExtendedFeeDataList,
                      );
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void applySearchAndFilter(List<ExtendedFeeDataList> sourceList) {
    filteredList = sourceList;
    Utils.printLog(
      "filteredListData = ${filteredList.length}  sourceListData  = ${sourceList.length}",
    );

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((item) {
        return item.transactions?.any((container) {
              return container.orderId.toString().contains(_searchQuery);
              false;
            }) ??
            false;
      }).toList();
    }

    if (_searchQuery.isEmpty && selectedMonthYear != null) {
      final selectedMonthName = selectedMonthYear!.split('–')[0];
      final selectedMonthIndex = DateMonthUtils.getMonthIndex(
        selectedMonthName,
      );

      filteredList = filteredList.where((item) {
        final itemMonth = DateTime.parse(item.monthYear!).month;
        return itemMonth == selectedMonthIndex;
      }).toList();
    }
  }

  Widget _cardItem(Transactions item) {
    final theme = Theme.of(context);

    return Container(
        margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Constant.Green4,
              Constant.PrimaryColor],
          ),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
          border: Border.all(color: Constant.PrimaryDarkColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? '',
                    style: const TextStyle(
                      color: Constant.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_04),
                  Text(
                    item.formattedDateTime ?? '',
                    style: TextStyle(color: Constant.white, fontSize: Constant.CONTAINER_SIZE_12),
                  ),
                ],
              ),
            ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Strings.BOWL_IMG,
                  width: Constant.CONTAINER_SIZE_14,
                  height: Constant.CONTAINER_SIZE_14,
                ),
                SizedBox(width: Constant.SIZE_04),

                Text(
                  "${item.totalQuantity ?? 0}",
                  style: TextStyle(
                  color: Constant.white,
                  fontSize: Constant.CONTAINER_SIZE_13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            ),

                SizedBox(height: Constant.SIZE_06),

                Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Strings.DIRHAM_IMG,
                    width: Constant.CONTAINER_SIZE_14,
                    height: Constant.CONTAINER_SIZE_14,
                  ),

                Text(
                  '${item.totalAmount ?? 0}',
                  style: TextStyle(
                    color: theme.secondaryHeaderColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: Constant.SIZE_06),

              ],
            ),
          ],
        ),
  ],
        ),
    );
  }

  Widget _filterButton() {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Constant.CONTAINER_SIZE_18,
        vertical: Constant.CONTAINER_SIZE_12,
      ),
      decoration: BoxDecoration(
        color: theme.secondaryHeaderColor,
        borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  color: Constant.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.SORT,
                  style: TextStyle(
                    color: Constant.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Constant.CONTAINER_SIZE_12,
            ),
            height: Constant.CONTAINER_SIZE_18,
            width: Constant.SIZE_02,
            color: Constant.black,
          ),

          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Constant.black,
                  size: Constant.CONTAINER_SIZE_20,
                ),
                SizedBox(width: Constant.SIZE_06),
                Text(
                  Strings.FILTER,
                  style: TextStyle(
                    color: Constant.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthHeader(String title, double amount) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.SIZE_06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Constant.white,
              fontSize: Constant.CONTAINER_SIZE_15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Image.asset(
                Strings.DIRHAM_IMG,
                height: Constant.CONTAINER_SIZE_16,
                width: Constant.CONTAINER_SIZE_16,
              ),
              SizedBox(width: Constant.SIZE_06),
              Text(
                amount.toStringAsFixed(2),
                style: TextStyle(color: Constant.white),
              ),
            ],
          ),
        ],
      ),
    );
  }


  _getExtendedNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(transactionProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.EXTENDED_FEE}';
          // '${widget.userId}';
          ref.read(getExtendedFeeProvider(url));
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
