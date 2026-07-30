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
    ConsumerState<TransactionExtendedFeeScreen> createState() => _TransactionScreenState();
  }

  class _TransactionScreenState extends ConsumerState<TransactionExtendedFeeScreen> {
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
        backgroundColor: Color(0xFF0E3B2E),
        body: Stack(
        children: [
          Column(
            children: [
              _searchBar(),

              Expanded(
                child: filteredList.isEmpty && !transactionState.isLoading
                    ? Center(
                  child: Utils.getErrorText(Strings.NO_TRANSACTION_EXTENDED_FEE_DATA),
                )
                    : ListView.builder(
                  padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final extendedData = filteredList.elementAt(index);
                    final transactions = extendedData.transactions ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _monthHeader(extendedData.monthYear ?? "", extendedData.monthTotalAmount ?? 0),
                        SizedBox(height: Constant.SIZE_06),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: transactions.length,
                          itemBuilder: (_, i) => _cardItem(
                              transactions[i]),
                          ),
                        ],

                    );
                  },
                ),
              ),
            ],
          ),

          if (transactionState.isLoading)
            const Center(child: CircularProgressIndicator(
              color: Constant.gold,
            )),
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
            applySearchAndFilter(ref.read(transactionProvider).getExtendedFeeDataList);
          });
        },
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_EXTENDED_FEE,
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
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
            icon: const Icon(Icons.filter_list, color: Colors.white),
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
                      applySearchAndFilter(ref.read(transactionProvider).getExtendedFeeDataList);
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
    Utils.printLog("filteredListData = ${filteredList.length}  sourceListData  = ${sourceList.length}");


    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((item) {
        return item.transactions?.any((container) {
          return container.name
              ?.toLowerCase()
              .contains(_searchQuery.toLowerCase()) ??
              false;
        }) ??
            false;
      }).toList();
    }

    if (_searchQuery.isEmpty && selectedMonthYear != null) {
      final selectedMonthName = selectedMonthYear!.split('–')[0];
      final selectedMonthIndex =
      DateMonthUtils.getMonthIndex(selectedMonthName);

      filteredList = filteredList.where((item) {
        final itemMonth = DateTime.parse(item.monthYear!).month;
        return itemMonth == selectedMonthIndex;
      }).toList();
    }
  }

  Widget _cardItem(Transactions item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1E5A45),
            Color(0xFF164434),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [

          /// Left Side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  item.name ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  item.formattedDateTime ?? "",
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          /// Right Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Row(
                children: [
                  Image.asset(
                    "assets/images/bowl_img.png",
                    height: 14,
                    width: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${item.totalQuantity ?? 0}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 5),

              Row(
                children: [

                  Image.asset(
                      "assets/images/diarhm.png",
                  height: 16,
                  width: 16,
                  ),

                  Text(
                    "${item.totalAmount ?? 0}",
                    style: const TextStyle(
                      color: Color(0xFFFFC107),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          )
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
                    color: Colors.black,
                    size: Constant.CONTAINER_SIZE_20,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Text(
                    Strings.SORT,
                    style: TextStyle(
                      color: Colors.black,
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
              color: Colors.black26,
            ),

            InkWell(
              onTap: () {},
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: Colors.black,
                    size: Constant.CONTAINER_SIZE_20,
                  ),
                  SizedBox(width: Constant.SIZE_06),
                  Text(
                    Strings.FILTER,
                    style: TextStyle(
                      color: Colors.black,
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

  Widget _monthHeader(String month, int amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF1A4E3A),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            month,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          Row(
            children: [

              Image.asset(
                "assets/images/diarhm.png",
                width: 16,
                height: 16,
              ),

              Text(
                "$amount",
                style: const TextStyle(
                  color: Color(0xFFFFC107),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
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
          final transactionState = ref.read(transactionProvider);
          if (isNetworkAvailable) {
            transactionState.setIsLoading(true);

            final url = '${NetworkUrls.EXTENDED_FEE}';
               // '${widget.userId}';
            ref.read(getExtendedFeeProvider(url));
          } else {
            transactionState.setIsLoading(false);
            Utils.showToast(Strings.NO_INTERNET_CONNECTION);
          }
        });
      } catch (e) {
        Utils.printLog('Error in visitor button onPressed: $e');
      }
    }
  }
