import 'package:container_tracking/Screen/users/screens/user_borrowed_details_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/filter_screen_2.dart';
import '../../../constants/imports.util.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/date_month_utils.dart';
import '../../../utils/utility.dart';
import '../model/user_borrowed_data.dart';
import '../provider/user_provider.dart';


class UserReturnedScreen extends ConsumerStatefulWidget {
  final int userId;

  UserReturnedScreen({super.key, required this.userId});

  @override
  ConsumerState<UserReturnedScreen> createState() => _BorrowedTabScreenState();
}

class _BorrowedTabScreenState extends ConsumerState<UserReturnedScreen> {
  @override
  void initState() {
    super.initState();
    Utils.getToken();
    _getBorrowedData();
  }

  List<BorrowedUiItem> filteredList = [];

  final searchController = TextEditingController();

  String? selectedMonthYear;
  int selectedYear = DateTime.now().year;

  String _searchQuery = '';


  void applySearchAndFilter(List<BorrowedUiItem> sourceList) {
    filteredList = sourceList;

    if (_searchQuery.isNotEmpty) {
      filteredList = filteredList.where((item) {
        return item.restaurantName
            .toLowerCase()
            .contains(_searchQuery.toLowerCase());
      }).toList();
    }
    if(_searchQuery.isEmpty) {
      if (selectedMonthYear != null) {
        final selectedMonthName = selectedMonthYear!.split('–')[0];
        final selectedMonthIndex = DateMonthUtils.getMonthIndex(selectedMonthName);

        filteredList = filteredList.where((item) {
          final itemMonth = DateTime
              .parse(item.date)
              .month;
          return itemMonth == selectedMonthIndex;
        }).toList();
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(userProvider);
    final list = historyState.borrowedList;
    if (filteredList.isEmpty && historyState.borrowedList.isNotEmpty) {
      applySearchAndFilter(historyState.borrowedList);
    }

    final groupedData = _groupByMonth(filteredList);
    return Stack(
      children: [
        Column(
          children: [
            _searchBar(),

            Expanded(
              child: list.isEmpty && !historyState.isLoading
                  ? Center(
                child: Utils.getErrorText(Strings.NO_RETURNED_CONTAINERS),
              )
                  : ListView.builder(
                padding: EdgeInsets.all(Constant.CONTAINER_SIZE_12),
                itemCount: groupedData.keys.length,
                itemBuilder: (context, index) {
                  final month = groupedData.keys.elementAt(index);
                  final items = groupedData[month]!;
                  final totalContainers = _getTotalContainerCount(items);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _monthHeader(month, totalContainers),
                      SizedBox(height: Constant.SIZE_06),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (_, i) => _historyCard(
                          context: context,
                          item: items[i],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),

        if (historyState.isLoading)
          const Center(child: CircularProgressIndicator(
            color: Constant.gold,
          )),
      ],
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
            applySearchAndFilter(ref.read(userProvider).borrowedList);
          });
        },
        cursorColor: Constant.white,
        style: TextStyle(color: Constant.white),
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_RESTAURANT,
          hintStyle: TextStyle(color: Constant.BeigeColor),
          prefixIcon: Icon(Icons.search, color: Constant.BeigeColor),
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
            icon: Icon(Icons.filter_list, color: Constant.BeigeColor),
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
                      applySearchAndFilter(ref.read(userProvider).borrowedList);
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


  Map<String, List<BorrowedUiItem>> _groupByMonth(List<BorrowedUiItem> list) {
    final Map<String, List<BorrowedUiItem>> grouped = {};

    for (final item in list) {
      final monthKey = DateMonthUtils.getMonthYear(item.date);

      grouped.putIfAbsent(monthKey, () => []);
      grouped[monthKey]!.add(item);
    }

    return grouped;
  }


  int _getTotalContainerCount(List<BorrowedUiItem> items) {
    int total = 0;
    for (final item in items) {
      total += item.containerCount;
    }
    return total;
  }

  Widget _monthHeader(String title, int count) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constant.SIZE_06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Constant.BeigeColor,
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
              Text("$count", style: TextStyle(color: Constant.BeigeColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyCard({
    required BuildContext context,
    required BorrowedUiItem item,
  }) {
    return InkWell(
      onTap: () {
        _openDetailDialog(context, item);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Constant.SIZE_08),
        padding: EdgeInsets.all(Constant.SIZE_10),
        decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          border: Border.all(color: Constant.grey.withOpacity(0.2)),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    item.restaurantName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Constant.BeigeColor,
                      fontSize: Constant.CONTAINER_SIZE_16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Constant.BeigeColor,
                            fontSize: Constant.CONTAINER_SIZE_13,
                          ),
                        ),
                      ),

                      Text(
                        item.containerCount.toString(),
                        style: TextStyle(
                          color: Constant.PrimaryAssentColor,
                          fontSize: Constant.CONTAINER_SIZE_18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(width: Constant.SIZE_06),

                      Icon(
                        Icons.arrow_forward_ios,
                        size: Constant.CONTAINER_SIZE_14,
                        color: Constant.BeigeColor,
                      ),
                    ],
                  ),

                  Text(
                    '${item.date} | ${item.time}',
                    style: TextStyle(
                      color: Constant.BeigeColor,
                      fontSize: Constant.CONTAINER_SIZE_12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetailDialog(BuildContext context, BorrowedUiItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ReceiveDetailsDialog(title: Strings.RETURNED_DETAILS, items: [item],
              isReturned: true,
              borrowedOn:'${item.date} | ${item.time}' ,
              returnedOn:'${item.returnedTime} | ${item.returnedTime}'),
    );
  }

  _getBorrowedData() async {
    try {
      await ref.read(networkProvider.notifier).isNetworkAvailable().then((
          isNetworkAvailable,
          ) {
        Utils.printLog("isNetworkAvailable::$isNetworkAvailable");
        if (isNetworkAvailable) {
          ref.read(userProvider).clearBorrowedList();
          ref.read(userProvider).setIsLoading(true);
          final int year = DateTime.now().year;

          final url = '${NetworkUrls.RETURNED_DATA}userId=${widget.userId}';//&year=$year
          Utils.printLog("Fetching URL: $url");
          ref.read(borrowedProvider(url));
        } else {
          Utils.showToast(Strings.NO_INTERNET_CONNECTION);
        }
      });
    } catch (e) {
      ref.read(userProvider).setIsLoading(false);
      Utils.showToast(e.toString());
    }
    FocusScope.of(context).unfocus();
  }
}