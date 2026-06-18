import 'package:container_tracking/Screen/users/model/user_sold_container_data.dart';
import 'package:container_tracking/Screen/users/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_provider/network_provider.dart';
import '../../../common_widgets/filter_screen_2.dart';
import '../../../constants/imports.util.dart';
import '../../../constants/network_urls.dart';
import '../../../constants/string_utils.dart';
import '../../../utils/date_month_utils.dart';
import '../../../utils/utility.dart';
import '../model/user_borrowed_data.dart';
import '../model/user_sold_details.dart';


class UserSoldScreen extends ConsumerStatefulWidget {
  final int userId;

  const UserSoldScreen({super.key, required this.userId});

  @override
  ConsumerState<UserSoldScreen> createState() => _userSoldTabState();
}
class _userSoldTabState extends ConsumerState<UserSoldScreen> {


  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSoldNetworkCall();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<SoldDataList> filteredList = [];

  //final searchController = TextEditingController();

  String? selectedMonthYear;
  int selectedYear = DateTime.now().year;

  String _searchQuery = '';


  // void applySearchAndFilter(List<SoldDataList> sourceList) {
  //   filteredList = List.from(sourceList);
  //
  //   // Search Filter
  //   if (_searchQuery.isNotEmpty) {
  //     filteredList = filteredList.where((item) {
  //       if (item.dateWiseSoldContainers == null ||
  //           item.dateWiseSoldContainers!.isEmpty ||
  //           item.dateWiseSoldContainers![0].products == null ||
  //           item.dateWiseSoldContainers![0].products!.isEmpty ||
  //           item.dateWiseSoldContainers![0].products![0].productName == null) {
  //         return false;
  //       }
  //
  //       return item
  //           .dateWiseSoldContainers![0]
  //           .products![0]
  //           .productName!
  //           .toLowerCase()
  //           .contains(_searchQuery.toLowerCase());
  //     }).toList();
  //   }

    // Month Filter
  //   if (selectedMonthYear != null) {
  //     final selectedMonthName = selectedMonthYear!.split('–')[0];
  //     final selectedMonthIndex =
  //     DateMonthUtils.getMonthIndex(selectedMonthName);
  //
  //     filteredList = filteredList.where((item) {
  //       return item.monthYear == selectedMonthIndex;
  //     }).toList();
  //   }
  //
  //   setState(() {});
  // }
  void applySearchAndFilter(List<SoldDataList> sourceList) {
    filteredList = List.from(sourceList);

    // Search Filter
    if (_searchQuery.trim().isNotEmpty) {
      filteredList = filteredList.where((item) {
        if (item.dateWiseSoldContainers == null ||
            item.dateWiseSoldContainers!.isEmpty) {
          return false;
        }

        return item.dateWiseSoldContainers!.any((dateWise) {
          if (dateWise.products == null || dateWise.products!.isEmpty) {
            return false;
          }

          return dateWise.products!.any((product) {
            return (product.productName ?? '')
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          });
        });
      }).toList();
    }

    // Month Filter
    if (selectedMonthYear != null &&
        selectedMonthYear!.trim().isNotEmpty) {
      filteredList = filteredList.where((item) {
        return (item.monthYear ?? '')
            .toLowerCase()
            .contains(selectedMonthYear!.toLowerCase());
      }).toList();
    }

    setState(() {});
  }

  final List<SoldDetails> containers = [
    SoldDetails(
        resturantName: Strings.RESTAURANT_1,
        containerName: Strings.CONTAINER_1,
        code: Strings.CODE_1,
        volume: Strings.VOLUME_1,
        qty: 3,
        image: "assets/images/cups.png",
        date: Strings.DATE_1,
        price: "120"
    ),
    SoldDetails(
        resturantName: Strings.RESTAURANT_2,
        containerName: Strings.CONTAINER_2,
        code: Strings.CODE_2,
        volume: Strings.VOLUME_2,
        qty: 5,
        image: "assets/images/cups.png",
        date: Strings.DATE_2,
        price: "120"
    ),
    SoldDetails(
        resturantName: Strings.RESTAURANT_2,
        containerName: Strings.CONTAINER_3,
        code: Strings.CODE_3,
        volume: Strings.VOLUME_3,
        qty: 2,
        image: "assets/images/cups.png",
        date: Strings.DATE_3,
        price: "120"
    ),
    SoldDetails(
        resturantName: Strings.RESTAURANT_3,
        containerName: Strings.CONTAINER_4,
        code: Strings.CODE_3,
        volume: Strings.VOLUME_4,
        qty: 5,
        image: 'assets/images/cups.png',
        date: Strings.DATE_3,
        price: "120"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final userProviders = ref.watch(userProvider);
    if (filteredList.isEmpty) {
      filteredList = List.from(userProviders.soldDataList);
    }
    return Column(
      children: [
        _searchBar(),
        Expanded(
          child: ListView(
            padding:  EdgeInsets.all(Constant.CONTAINER_SIZE_12),
            children: _groupByMonth().entries.map((entry) {
              final month = entry.key;
              final items = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _monthHeader(month, items.length),
                  SizedBox(height: Constant.SIZE_06),

                  ...items.map(
                        (item) => _soldItemCard(
                      item: item,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
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
            applySearchAndFilter(ref.read(userProvider).soldDataList);
          });
        },
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: Strings.SEARCH_BY_REST_NAME,
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
                      applySearchAndFilter(ref.read(userProvider).soldDataList);
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

  String _getMonthYear(String date) {
    final parts = date.split('|').first.trim(); // 22/11/2025
    final dateParts = parts.split('/'); // [22, 11, 2025]

    final month = int.parse(dateParts[1]);
    final year = dateParts[2];

    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return '${months[month - 1]} $year';
  }

  Map<String, List<SoldDetails>> _groupByMonth() {
    final Map<String, List<SoldDetails>> grouped = {};

    for (final item in containers) {
      final monthKey = _getMonthYear(item.date);

      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      grouped[monthKey]!.add(item);
    }

    return grouped;
  }

  _soldItemCard({
    required SoldDetails item,
  }) {
    return Container(
      margin:  EdgeInsets.symmetric(vertical: Constant.SIZE_08),
      padding:  EdgeInsets.all(Constant.SIZE_10),

      decoration: BoxDecoration(
          color: Constant.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_16),
          border: Border.all(
              color: Constant.grey.withOpacity(0.2)
          )
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            item.date,
            style:  TextStyle(
              color: Colors.white70,
              fontSize: Constant.CONTAINER_SIZE_12,
            ),
          ),

          SizedBox(height: Constant.SIZE_10),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(Constant.CONTAINER_SIZE_12),
                child: Image.asset(
                  item.image,
                  height: Constant.CONTAINER_SIZE_60,
                  width: Constant.CONTAINER_SIZE_60,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: Constant.CONTAINER_SIZE_14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.containerName,
                      style:  TextStyle(
                        color: Colors.white,
                        fontSize: Constant.CONTAINER_SIZE_15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),


                    Text(
                      item.code,
                      style:  TextStyle(
                        color: Colors.white70,
                        fontSize: Constant.CONTAINER_SIZE_13,
                      ),
                    ),


                    Text(
                      item.qty.toString(),
                      style:  TextStyle(
                        color: Colors.white60,
                        fontSize: Constant.CONTAINER_SIZE_12,
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
                      Image.asset('assets/images/img.png',
                        height: Constant.CONTAINER_SIZE_16,
                        width: Constant.CONTAINER_SIZE_16,),
                      SizedBox(width: Constant.SIZE_04),

                      Text(
                        item.qty.toString(),
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: Constant.CONTAINER_SIZE_14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.currency_rupee, size: Constant.CONTAINER_SIZE_18, color: Colors.white,),
                      Text(
                        item.price!,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: Constant.CONTAINER_SIZE_18,
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
    );
  }

  Widget _monthHeader(String title, int count) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: Constant.SIZE_06),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:  TextStyle(
              color: Colors.white,
              fontSize: Constant.CONTAINER_SIZE_15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(

            children: [
              Image.asset('assets/images/img.png',
                height: Constant.CONTAINER_SIZE_16,
                width: Constant.CONTAINER_SIZE_16,),
              SizedBox(width: Constant.SIZE_06),
              Text(
                "$count",
                style: const TextStyle(color: Colors.white),
              )
            ],
          )
        ],
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





