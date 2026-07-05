import 'package:container_tracking/Screen/users/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/custom_app_bar.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../constants/imports.util.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/no_data_custom_text.dart';
import '../../../utils/utility.dart';
import 'package:container_tracking/transactions/screens/transaction_extendedfee_screen.dart';
import 'package:container_tracking/transactions/screens/transaction_sold_screens.dart';
import 'package:container_tracking/transactions/screens/transaction_subscription_screen.dart';
import '../../Screen/users/model/user_sold_container_data.dart';
import '../../Screen/users/model/user_sold_details.dart';
import '../../common_widgets/filter_screen_2.dart';
import '../../utils/date_month_utils.dart';

class TransactionSoldScreen extends ConsumerStatefulWidget {
  final int userId;


  TransactionSoldScreen({super.key, required this.userId});

  @override
  ConsumerState<TransactionSoldScreen> createState() => _TransactionSoldState();
}

class _TransactionSoldState extends ConsumerState<TransactionSoldScreen> {
  String _searchQuery = '';
  String? selectedMonthYear;
  late List<SoldDataList> filteredList = [];
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSoldNetworkCall();
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(userProvider);
    if (filteredList.isEmpty && historyState.soldContainerList.isNotEmpty) {
      applySearchAndFilter(historyState.soldContainerList);
    }
    return Scaffold(
        backgroundColor: Color(0xFF0E3B2E),
        body: Column(
              children: [
                _searchBar(),
                Expanded(
                  child: historyState.soldContainerList.isEmpty
          ? Center(
        child: NoDataFoundCustomText(text: Strings.NO_SOLD_CONTAINER),
                  )
          : ListView.separated(
        padding: EdgeInsets.only(top: Constant.CONTAINER_SIZE_10),
        itemCount: historyState.filteredList.length,
        itemBuilder: (context, index) {
          final month =
              historyState.soldContainerList[index].monthYear;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _monthHeader(
                month ?? "",
                historyState.soldContainerList.length,
              ),
              ...historyState
                  .soldContainerList[index]
                  .dateWiseSoldContainers!
                  .map((item) => _soldItemCard(item: item)),
            ],
          );
        },
        separatorBuilder: (context, index) =>
            SizedBox(height: Constant.CONTAINER_SIZE_12),
                  ),
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
            applySearchAndFilter(ref.read(userProvider).soldContainerList);
          });
        },
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_SOLD,
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
                      applySearchAndFilter(
                        ref.read(userProvider).soldContainerList,
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
  void applySearchAndFilter(List<SoldDataList> sourceList) {
    ref.read(userProvider).setFilteredList(sourceList);

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((item) {
        return item.dateWiseSoldContainers?.any((sold) {
          return (sold.productName ?? "")
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
              (sold.productUniqueId ?? "")
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
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

  Widget _soldItemCard({required DateWiseSoldContainers item}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF184D3B), Color(0xFF0E3A2D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _dateItem(
                    title: "Borrowed on:",
                    value: item.borrowedOn ?? "",
                  ),
                  _dateItem(title: "Due on:", value: item.dueOn ?? ""),
                  _dateItem(title: "Sold on:", value: item.soldOn ?? ""),
                ],
              ),

              const SizedBox(height: 14),

              Divider(color: Colors.white.withOpacity(0.15), height: 1),

              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        "${NetworkUrls.IMAGE_BASE_URL}${item.productImageUrl}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/no_image_container.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.productUniqueId ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "${item.capacity}ml",
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/bowl_img.png',
                            height: Constant.CONTAINER_SIZE_16,
                            width: Constant.CONTAINER_SIZE_16,
                          ),
                          SizedBox(width: Constant.SIZE_04),
                          Text(
                            item.soldQuantity?.toString() ?? "",
                            style: theme.textTheme.titleSmall!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Image.asset(
                            'assets/images/diarhm.png',
                            height: Constant.CONTAINER_SIZE_16,
                            color: Constant.orange,
                            colorBlendMode: BlendMode.srcIn,
                          ),
                          SizedBox(width: Constant.SIZE_02),
                          Text(
                            item.soldAmount?.toString() ?? "",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: Color(0xFFE5C84B),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _monthHeader(String title, int count) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: Constant.CONTAINER_SIZE_12,
          horizontal: Constant.CONTAINER_SIZE_16,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: Constant.CONTAINER_SIZE_15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  _getSoldNetworkCall() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        final orderState = ref.read(userProvider);
        if (isNetworkAvailable) {
          orderState.setIsLoading(true);

          final url = '${NetworkUrls.GET_SOLD_CONTAINER}${widget.userId}';
          ref.read(getSoldContainerProvider(url));
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
