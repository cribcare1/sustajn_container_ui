import 'package:container_tracking/transactions/models/transaction_subscription_data.dart';
import 'package:container_tracking/transactions/screens/transaction_subscription_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_provider/network_provider.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/number_constants.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/date_month_utils.dart';
import '../../../utils/utility.dart';
import '../../common_widgets/filtered_screen_3.dart';
import '../provider_service/transaction_provider.dart';

class TransactionSubscriptionScreen extends ConsumerStatefulWidget {
  final int userId;

  const TransactionSubscriptionScreen({super.key, required this.userId});

  @override
  ConsumerState<TransactionSubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState
    extends ConsumerState<TransactionSubscriptionScreen> {
  List<SubscriptionDataList> filteredList = [];
  final searchController = TextEditingController();
  String _searchQuery = '';
  String? selectedMonthYear;
  String? selectedPlanType;

  @override
  void initState() {
    super.initState();
    _getSubscriptionNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);
    final damageList = transactionState.getSubscriptionDataList;
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
                    ? Center(child: Utils.getErrorText(Strings.NO_SUBSCRIPTION))
                    : ListView.builder(
                        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final subscriptionData = filteredList.elementAt(
                            index,
                          );

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _monthHeader(
                                subscriptionData.monthYear!,
                                subscriptionData
                                    .monthWiseTotalSusbcriptionAmount!,
                              ),
                              SizedBox(height: Constant.SIZE_06),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: subscriptionData
                                    .dateWiseSubscription!
                                    .length,
                                itemBuilder: (_, i) => _cardItem(
                                  subscriptionData.dateWiseSubscription![i],
                                ),
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
              ref.read(transactionProvider).getSubscriptionDataList,
            );
          });
        },
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_REST,
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
                builder: (_) => ReusableFilter(
                  title: "Filters",
                  leftTabTitle: "Month",
                  leftTabTitles: "Plan Type",
                  options: months,
                  planType: const ["Pay-per-use", "Customization"],
                  selectedValue: selectedMonthYear,
                  selectedPlanType: selectedPlanType,
                  onApply: (month, planType) {
                    setState(() {
                      selectedMonthYear = month;
                      selectedPlanType = planType;

                      applySearchAndFilter(
                        ref.read(transactionProvider).getSubscriptionDataList,
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

  void applySearchAndFilter(List<SubscriptionDataList> sourceList) {
    filteredList = sourceList;
    Utils.printLog(
      "filteredListData = ${filteredList.length}  sourceListData  = ${sourceList.length}",
    );

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((item) {
        return item.dateWiseSubscription?.any((container) {
              return container.name?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
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

  Widget _cardItem(DateWiseSubscription item) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _openDetailDialog(context, item),
      child: Container(
        margin: EdgeInsets.only(bottom: Constant.CONTAINER_SIZE_12),
        padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1F5A46), Color(0xFF0E3B2E)],
          ),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_14),
          border: Border.all(color: Colors.white70),
        ),
        child: Row(
          children: [
            // Container(
            //   height: Constant.CONTAINER_SIZE_50,
            //   width: Constant.CONTAINER_SIZE_50,
            //   decoration: BoxDecoration(
            //     color: Colors.white10,
            //     borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_10),
            //   ),
            //   child: Image.asset(getContainerImage(item.type)),
            // ),
            // SizedBox(width: Constant.CONTAINER_SIZE_12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Constant.SIZE_04),
                  Text(
                    item.planType!,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: Constant.CONTAINER_SIZE_12,
                    ),
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Text(
                  '${item.amount!}',
                  style: TextStyle(
                    color: theme.secondaryHeaderColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: Constant.SIZE_06),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: Constant.CONTAINER_SIZE_14,
                ),
              ],
            ),
          ],
        ),
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

  Widget _monthHeader(String title, double count) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.SIZE_06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              Image.asset(
                Strings.BOWL_IMG,
                height: Constant.CONTAINER_SIZE_16,
                width: Constant.CONTAINER_SIZE_16,
              ),
              SizedBox(width: Constant.SIZE_06),
              Text("$count", style: const TextStyle(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  void _openDetailDialog(BuildContext context, DateWiseSubscription item) {
    // //final items = (item.name ?? []).map((product) {
    //   return BorrowedUiItem(
    //     restaurantName: '',
    //     resturantAddress: '',
    //     productName: product.productName ?? '',
    //     capacity: product.capacity ?? 0,
    //     containerCount: item.dateWiseTotalDamageContainers ?? 0,
    //     productId: product.productUniqueId ?? '',
    //     date: item.localDateTime ?? '',
    //     time: '',
    //     imageUrl: product.productImageUrl ?? '',
    //   );
    // //}).toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SubscriptionDetailsDialog(items: item),
    );
  }

  _getSubscriptionNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
        isNetworkAvailable,
      ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(transactionProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.SUBSCRIPTION}';
          ref.read(getSubscriptionProvider(url));
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
